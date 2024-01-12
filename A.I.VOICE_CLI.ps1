<#
    .SYNOPSIS
        WindowsのCLI(PowerShell)からA.I.VOICEでテキストを読み上げるスクリプトです。

    .DESCRIPTION
        A.I.VOICE Editor API を利用してText, VoicePresetNames, CurrentVoicePresetName を取得・設定します。
        Text: テキスト形式の入力テキストを取得または設定します。
        VoicePresetNames: 登録されているボイスプリセット名を取得します。
        CurrentVoicePresetName: 現在のボイスプリセット名を取得または設定します。
        スクリプト内の$PathをAI.Talk.Editor.Api.dllの適切なパスに指定してください。

    .PARAMETER text
        読み上げテキストの設定を設定します。
        原則必須のパラメータです。パラメータ指定文字列(-text)は省略可能です。

    .PARAMETER vpresetlist
        ボイスプリセットのリストを取得します。
        省略可能なパラメータです。このオプションが有効な場合は text パラメータの処理が行われません。

    .PARAMETER vpreset
        ボイスプリセットを設定します。
        省略可能なパラメータです。省略した場合は現在のボイスプリセットを利用します。

    .PARAMETER help
        ヘルプを表示します。

    .EXAMPLE
        A.I.VOICE_CLI.ps1 exampletext
        現在のボイスプリセットで"exampletext"を読み上げます。

    .EXAMPLE
        A.I.VOICE_CLI.ps1 -vpresetlist
        ボイスプリセットの一覧を出力します。
 
    .EXAMPLE
        A.I.VOICE_CLI.ps1 -text exampletext -vpreset VoicePresetName
        指定したボイスプリセットで"exampletext"を読み上げます。
        読み上げ後は元のボイスプリセットに戻します。

    .LINK
        https://github.com/gomadarecats/A.I.VOICE_CLI
        https://aivoice.jp/manual/editor/API/html/d7d48194-41c9-aeda-7971-a604090d36c9.htm
#>

Param(
  [string]$text,
  [switch]$vpresetlist,
  [string]$vpreset,
  [switch]$help
)

if ($help -eq $true) {
  Get-Help $PSCommandPath -Detailed
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
