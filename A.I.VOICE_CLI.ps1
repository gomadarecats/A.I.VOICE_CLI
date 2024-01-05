$Path = "C:\Program Files\AI\AIVoice\AIVoiceEditor\AI.Talk.Editor.Api.dll"
Add-Type -Path $Path

$ttsControl = [AI.Talk.Editor.Api.TtsControl]::new()
$AvailableHosts = $ttsControl.GetAvailableHostNames()

if ($AvailableHosts.length -gt 0) {
  $CurrentHost = $AvailableHosts[0]
} else {
  exit 1
}

function speech($text) {
  try {
    if ($ttsControl.IsInitialized -eq $false) {
      $ttsControl.Initialize($CurrentHost)
    }
  }
  catch {
    Write-Host $_.Exception.Message
    exit 1
  }
  try {
    if ($ttsControl.Status -eq "NotRunning") {
      $ttsControl.StartHost()
    }
    if ($ttsControl.Status -eq "NotConnected") {
      $ttsControl.Connect()
    }
    while ( $ttsControl.Status -eq "Busy" ) {
      sleep 1
    }
    $ttsControl.Text = $text
    $ttsControl.Play()
  }
  catch {
    Write-Host $_.Exception.Message
    exit 1
  }
}

speech($Args[0])

