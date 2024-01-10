Param(
  [string]$text,
  [switch]$vpresetlist,
  [string]$vpreset
)

if (($vpresetlist -eq $false) -and ([string]::IsNullOrEmpty($text))) {
  echo "次のパラメーターに値を指定してください:"
  $text = Read-Host "text"
}

$Path = "C:\Program Files\AI\AIVoice\AIVoiceEditor\AI.Talk.Editor.Api.dll"
Add-Type -Path $Path

$ttsControl = [AI.Talk.Editor.Api.TtsControl]::new()
$AvailableHosts = $ttsControl.GetAvailableHostNames()

if ($AvailableHosts.length -gt 0) {
  $CurrentHost = $AvailableHosts[0]
} else {
  exit 1
}

function speech() {
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
  }
  catch {
    Write-Host $_.Exception.Message
    exit 1
  }
  if ($vpresetlist -eq $true) {
    echo $ttsControl.VoicePresetNames
    exit 0
  }
  try {  
    while ($ttsControl.Status -eq "Busy") {
      sleep 1
    }
    $vpreset_before = $ttsControl.CurrentVoicePresetName
    $ttsControl.CurrentVoicePresetName = "$vpreset"
    $ttsControl.Text = $text
    $ttsControl.Play()
    while ($ttsControl.Status -eq "Busy") {
      sleep 1
    }
    $ttsControl.CurrentVoicePresetName = "$vpreset_before"
  }
  catch {
    Write-Host $_.Exception.Message
    exit 1
  }
}

speech
