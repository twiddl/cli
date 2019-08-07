import os, tables

import argparse

import twiddl
import twiddl/runners

proc listJobs(env:TwiddlEnv) =
  for job in env.twiddlfile.jobs.values:
    echo job.name

proc listBuilds(env:TwiddlEnv) =
  for build in env.builds:
    echo build.id

proc buildSummary(build:Build) =
  echo "Build summary for build " & $build.id

proc build(env:TwiddlEnv, job:string) =
  if not env.twiddlfile.jobs.hasKey(job):
    echo "Job not found."
    return
  var build = newBuild(env, env.twiddlfile.jobs[job])
  runBuild(env, build)

when isMainModule:
  var p = newParser("twiddlcli"):
    help("The CLI interface for twiddl")
    option("--path", help="Path of the twiddl environment", default=".")
    command("list-jobs"):
      run:
        let env = openTwiddlEnv(opts.parentOpts.path)
        listJobs(env)
    command("list-builds"):
      run:
        let env = openTwiddlEnv(opts.parentOpts.path)
        listBuilds(env)
    command("show"):
      arg("id")
      run:
        let env = openTwiddlEnv(opts.parentOpts.path)
    command("build"):
      arg("job")
      run:
        let env = openTwiddlEnv(opts.parentOpts.path)
        build(env, opts.job)

  p.run()
