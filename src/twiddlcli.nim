import os, tables, terminal, terminaltables

import argparse

import twiddl
import twiddl/runners

proc listJobs(env:TwiddlEnv) =
  for job in env.twiddlfile.jobs.values:
    echo job.name

proc listBuilds(env:TwiddlEnv) =
  var t = newTerminalTable()
  t.tableWidth = 0
  t.setHeaders(@["ID", "Status"])
  for build in env.builds:
    t.addRow(@[$build.id,
               build.status.statusHumanReadable()])
  printTable(t)

proc statusColor(status:BuildStatus): ForegroundColor =
  case status
  of bsFinishedSuccessful: fgGreen
  of bsFinishedFailed: fgRed
  of bsRunning: fgCyan
  else: fgDefault

proc buildSummary(env:TwiddlEnv, buildID:string) =
  let b = env.builds[buildID.parseInt]
  echo "--- Build summary for build " & $b.id & " ---"
  styledEcho("Status: ", b.status.statusColor, $b.status)
  echo "Job name: " & b.job.name

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
        buildSummary(env, opts.id)
    command("build"):
      arg("job")
      run:
        let env = openTwiddlEnv(opts.parentOpts.path)
        build(env, opts.job)
    command("log"):
      arg("build")
      arg("id")
      run:
        let env = openTwiddlEnv(opts.parentOpts.path)

  p.run()
