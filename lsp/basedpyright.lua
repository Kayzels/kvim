return {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportMissingSuperCall = "none",
          reportPrivateUsage = "none",
          reportUnusedCallResult = "none",
          reportAny = "none",
          reportUninitializedInstanceVariable = "none",
          reportUnusedVariable = "none",
        },
      },
    },
  },
}
