# tokenize

`minishell` の **tokenize** 部分だけを切り出したスタンドアロン版です。
プロンプトから入力された文字列をシェル風にトークン分解し、配列形式で表示します。

## 必要環境

- macOS / Linux
- `cc` (clang or gcc)
- `make`
- `readline`
  - macOS: `brew install readline` (Makefile が自動で Homebrew のパスを拾います)
  - Linux: `apt install libreadline-dev` など

## ビルド

```sh
cd ~/Desktop/tokenize
make
```

`./tokenize` バイナリが生成されます。

その他のターゲット:

| target | 説明 |
| --- | --- |
| `make` / `make all` | ビルド |
| `make clean` | オブジェクトファイル削除 |
| `make fclean` | `clean` + バイナリ削除 |
| `make re` | `fclean` + `all` |

## 使い方

```sh
./tokenize
```

プロンプト (`tokenize$ `) が表示されます。
シェルコマンド風の文字列を入力すると、トークンに分解された結果が JSON ライクな配列形式で標準出力に表示されます。

### 例

```text
tokenize$ echo hello world
["echo", "hello", "world"]
tokenize$ ls -la | grep foo > out.txt
["ls", "-la", "|", "grep", "foo", ">", "out.txt"]
tokenize$ cat << EOF
["cat", "<<", "EOF"]
tokenize$ "quoted string" && another
[""quoted string"", "&&", "another"]
tokenize$ a >> b 2>&1
["a", ">>", "b", "2", ">&", "1"]
```

### 終了

- `Ctrl-D` (EOF) で `exit` と表示して終了します。
- 空行は無視され、次のプロンプトに戻ります。

## 認識するトークン

- **単語**: スペース区切り
- **クォート**: `"..."` / `'...'` (中身はそのまま保持)
- **演算子**: `|`, `||`, `&`, `&&`, `<`, `>`, `<<`, `>>`, `<<<`, `<<-`, `>&`, `<&`, `>|`, `<>`
- **括弧**: `(`, `)`

## ディレクトリ構成

```
tokenize/
├── Makefile
├── README.md
├── includes/
│   ├── tokenize.h        # 公開 API: t_list *tokenize(char *input);
│   └── constants.h       # SUCCESS / ERROR などの定数
├── libft/                # 依存ライブラリ
└── src/
    ├── main.c            # プロンプト + 結果表示
    └── tokenize/
        ├── tokenize.c            # メインの状態遷移ループ
        ├── tokenize_private.h    # 内部用ヘッダ
        ├── is_specific.c         # is_quote / is_operator など判定
        ├── state/                # 状態ごとのハンドラ
        │   ├── in_normal.c
        │   ├── in_normal/        # IN_NORMAL 内の分岐
        │   ├── in_double_quote.c
        │   ├── in_single_quote.c
        │   ├── in_operator.c
        │   ├── on_success.c
        │   └── on_error.c
        └── store/                # トークンバッファ操作
            ├── add_buffer.c
            ├── push_token.c
            └── free_store.c
```

## API

```c
#include "tokenize.h"

t_list  *tokens = tokenize(input);  // input は内部で free される
// tokens->content は char * (各トークン文字列)
ft_lstclear(&tokens, free);
```

- 引数 `input` の所有権は `tokenize` に渡されます (内部で `free` されます)。
- 返り値はトークン文字列を `content` に持つ `t_list *` の連結リスト。
- エラー時 (メモリ確保失敗 / クォートが閉じていない等) は `NULL` を返します。
