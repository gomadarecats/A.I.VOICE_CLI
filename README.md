# A.I.VOICE_CLI
概要

    WindowsのCLI(PowerShell)からA.I.VOICEでテキストを読み上げるスクリプトです。

構文

    A.I.VOICE_CLI.ps1 [[-text] <String>] [-vpresetlist] [[-vpreset] <String>] [-help] [<CommonParameters>]

説明

    A.I.VOICE Editor API を利用してText, VoicePresetNames, CurrentVoicePresetName を取得・設定します。
    Text: テキスト形式の入力テキストを取得または設定します。
    VoicePresetNames: 登録されているボイスプリセット名を取得します。
    CurrentVoicePresetName: 現在のボイスプリセット名を取得または設定します。
    スクリプト内の$PathをAI.Talk.Editor.Api.dllの適切なパスに指定してください。


パラメーター

    -text <String>
        読み上げテキストの設定を設定します。
        原則必須のパラメータです。パラメータ指定文字列(-text)は省略可能です。

    -vpresetlist [<SwitchParameter>]
        ボイスプリセットのリストを取得します。
        省略可能なパラメータです。このオプションが有効な場合は text パラメータの処理が行われません。

    -vpreset <String>
        ボイスプリセットを設定します。
        省略可能なパラメータです。省略した場合は現在のボイスプリセットを利用します。

    -help [<SwitchParameter>]
        ヘルプを表示します。
### Usage
```
<path>\A.I.VOICE_CLI.ps1 exampletext
    現在のボイスプリセットで"exampletext"を読み上げます。

<path>\A.I.VOICE_CLI.ps1 -vpresetlist
    ボイスプリセットの一覧を出力します。

<path>\A.I.VOICE_CLI.ps1 -text exampletext -vpreset <VoicePresetName>
    指定したボイスプリセットで"exampletext"を読み上げます。
    読み上げ後は元のボイスプリセットに戻します。
```

- A.I.VOICE Editorが起動していない場合は自動で起動します。
- $Path に <A.I.VOICE Editor インストールディレクトリ>\AI.Talk.Editor.Api.dll を入れてください
  - おそらくデフォルトであろう `C:\Program Files\AI\AIVoice\AIVoiceEditor\AI.Talk.Editor.Api.dll` を入れています

ps2exeでps1をexeにしたもをリリースしていますが、A.I.VOICE Editorのインストールディレクトリが\
`C:\Program Files\AI\AIVoice\AIVoiceEditor` 以外だと動きません

アイコンはBing Image Creatorさんに生成いただきました
