#' @export
writePackage <- function(...,
                         package.name, 
                         dir = ".",
                         clean = FALSE,
                         nClass_full_interface = TRUE) {
  ## rcpp_hello_world MUST be included because compileAttributes will not remove its entry
  ## even if the file is removed.
  require(Rcpp)
  if(grepl("_", package.name))
    stop("Package names are not allowed to have underscore characters.")
  objs <- list(...)
  if(length(objs)==1) {
    if(is.list(objs[[1]])) {
      objs <- objs[[1]]
    }
  }
  if(length(objs) > 1)
    stop("writePackage only supports one object as a first step of development")
  pkgDir <- file.path(dir, package.name)
  Rdir <- file.path(pkgDir, "R")
  srcDir <- file.path(pkgDir, "src")
  instDir <- file.path(pkgDir, "inst")
  codeDir <- file.path(instDir, "include", "nCompGeneratedCode")
  if(isNF(objs[[1]])) {
    nCompile_nFunction(objs[[1]],
                          control = list(endStage = "writeCpp"))
    RcppPacket <- NFinternals(objs[[1]])$RcppPacket
  } else if(isNCgenerator(objs[[1]])) {
    writtenNC1 <- nCompile_nClass(objs[[1]],
                                  control = list(endStage = "writeCpp"))
    RcppPacket <- NCinternals(objs[[1]])$RcppPacket
    if (isTRUE(nClass_full_interface)) {
      full_interface <- build_compiled_nClass(objs[[1]], quoted = TRUE)
    }
  } else {
    stop("provided object is not a nFunction or a nClass generator")
  }
  if(dir.exists(pkgDir)) {
    if(!clean)
      stop(paste0("Package ", package.name, " already exists in directory ", dir ))
    else
      unlink(pkgDir, recursive = TRUE)
  }
  ## The following eval(substitute(...), ...) construction is necessary
  ## because Rcpp.package.skeleton (and also pkgKitten::kitten) has a bug when used 
  ## directly as needed here from inside a function.
  eval(
    substitute(
      Rcpp.package.skeleton(PN,
                            path = DIR,
                            author = "This package was generated by the nCompiler"),
      list(DIR = dir,
           PN = package.name)),
    envir = .GlobalEnv)
  if(file.exists(file.path(pkgDir, "Read-and-delete-me")))
    file.remove(file.path(pkgDir, "Read-and-delete-me"))
  dir.create(instDir)
  dir.create(codeDir, recursive = TRUE)
  ## We write the code once for the package's DLL...
  nCompiler:::writeCpp_nCompiler(RcppPacket,
                                  dir = srcDir)
  ## ... and again for other packages that need to 
  ## compile against this package's source code.
  ## Otherwise, C++ source code is not present in an installed package.
  ## Compiling against source code is necessary because of
  ## heavy use of C++ templates.
  nCompiler:::writeCpp_nCompiler(RcppPacket,
                                 dir = codeDir)
  if (isNCgenerator(objs[[1]]) && isTRUE(nClass_full_interface)) {
    ## Write the nClass full interface to the package's R directory
    generator_name <- objs[[1]]$classname
    Rfile <- paste0(generator_name, '.R')
    Rfilepath <- file.path(Rdir, Rfile)
    con <- file(Rfilepath, open = 'w')
    deparsed_full_interface <- deparse(full_interface)
    deparsed_full_interface[1] <- paste0(
      generator_name, ' <- ', deparsed_full_interface[1]
    )
    deparsed_full_interface <- c(
      '## Generated by nCompiler::writePackage() -> do not edit by hand\n',
      deparsed_full_interface,
      paste0(generator_name, '$parent_env <- new.env()'),
      paste0(generator_name, '$.newCobjFun <- NULL')
    )
    writeLines(deparsed_full_interface, con)
    close(con)
  }
  DESCfile <- file.path(pkgDir, "DESCRIPTION")
  DESCRIPTION <- read.dcf(DESCfile)
  ## TO-DO: Make choice of what to include be smart about what is really needed.
  ## A nFunction might only need:
  ## DESCRIPTION[1, "LinkingTo"] <- paste(DESCRIPTION[1, "LinkingTo"], "RcppEigen", "RcppParallel", "nCompiler", sep = ",")
  ## A nClass might need:
    DESCRIPTION[1, "LinkingTo"] <- paste(DESCRIPTION[1, "LinkingTo"], "RcppEigen", "RcppEigenAD", "RcppParallel", "nCompiler", "Rcereal", sep = ",")
    ## It is conceivable that nCompLocal will need to be added to this at some point.
    ## If so, it will need to be installed in R's main library, not some local location.
  write.dcf(DESCRIPTION, DESCfile)
  compileAttributes(pkgdir = pkgDir)
  invisible(NULL)
}

#' @export
buildPackage <- function(package.name, 
                         dir = ".",
                         lib,
                         load = TRUE){
  if(!missing(lib)) {
    if(!dir.exists(lib))
      dir.create(lib)
  }
  staticLibLoc <- system.file('staticLib', package = 'nCompLocal')
  Sys.setenv("PKG_CXXFLAGS"="-std=c++11 -Wno-invalid-partial-specialization")
  Sys.setenv("PKG_LIBS"=paste0("-L \"",staticLibLoc,"\" -lnCompLocal"))
  ## possible missingness of lib propagates to install.packages
  install.packages(file.path(dir, package.name),
                   lib = lib,
                   repos = NULL,
                   type = "source",
                   quiet = TRUE)
  ok <- TRUE
  if(load) {
    if(missing(lib))
      lib <- NULL
    ## require can't take lib.loc as missing.
    ## It needs NULL to invoke default behavior.
    ok <- require(package.name, lib.loc = lib, character.only = TRUE)
  }
  ok
}
