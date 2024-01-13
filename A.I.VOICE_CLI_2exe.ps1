Param(
  [string]$text,
  [switch]$vpresetlist,
  [string]$vpreset,
  [switch]$help
)

if ($help -eq $true) {
  Start-Process -Filepath Powershell.exe -ArgumentList '-command &{echo "A.I.VOICE_CLI.exe` [[-text]` `<String`>]` [-vpresetlist]` [[-vpreset]` `<String`>]`n -text 読み上げテキストの設定を設定します。 原則必須のパラメータです。パラメータ指定文字列`(-text`)は省略可能です。`n -vpresetlist ボイスプリセットのリストを取得します。 省略可能なパラメータです。このオプションが有効な場合は` text` パラメータの処理が行われません。`n -vpreset ボイスプリセットを設定します。 省略可能なパラメータです。省略した場合は現在のボイスプリセットを利用します。`n example: A.I.VOICE_CLI.exe` exampletext →` 現在のボイスプリセットで`"exampletext`"を読み上げます。`n A.I.VOICE_CLI.exe` -vpresetlist →` ボイスプリセットの一覧を出力します。`n A.I.VOICE_CLI.exe` -text` exampletext` -vpreset` `<VoicePresetName`> →` 指定したボイスプリセットで`"exampletext`"を読み上げます。 →` 読み上げ後は元のボイスプリセットに戻します。`n "; pause}'
  exit 0
}

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
    $psarg = '-command &{echo ' + $ttsControl.VoicePresetNames + '`n; pause}'
    Start-Process -Filepath Powershell.exe -ArgumentList $psarg
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

