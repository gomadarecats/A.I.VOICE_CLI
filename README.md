# A.I.VOICE_CLI
CLIからA.I.VOICE Editorに文字を送る感じのスクリプト
### Usage
```
<path>\A.I.VOICE_CLI.ps1 exampletext
<path>\A.I.VOICE_CLI.ps1 -vpresetlist
<path>\A.I.VOICE_CLI.ps1 -text exampletext -vpreset <VoicePresetName>
```
```
OPTIONS
-text[string]         : 必須(-textは省略可能), 生成するテキストを入力
-vpresetlist[boolean] : 省略可, ボイスプリセットの一覧を表示
-vpreset[string]      : 省略可, ボイスプリセットを設定
```

- A.I.VOICE Editorが起動していない場合は自動で起動します。
- $Path に <A.I.VOICE Editor インストールディレクトリ>\AI.Talk.Editor.Api.dll を入れてください
  - おそらくデフォルトであろう `C:\Program Files\AI\AIVoice\AIVoiceEditor\AI.Talk.Editor.Api.dll` を入れています

ps2exeでps1をexeにしたもをリリースしていますが、A.I.VOICE Editorのインストールディレクトリが\
`C:\Program Files\AI\AIVoice\AIVoiceEditor` 以外だと動きません

アイコンはBing Image Creatorさんに作っていただきました
