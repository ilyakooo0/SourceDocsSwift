# SourceDocsSwift

Генернирует LaTeX-таблицы всех классов, структур и их полей и методов из проекта Xcode для вставки в техническую документацию.

## Установка

```bash
brew install ilyakooo0/tap/sourceDocsSwift
```

## Использование

```bash
sourceDocsSwift -i path/to/XcodePrjectDirectory/ -o path/to/output/doc.tex -s latex -l 1
```

```bash
sourceDocsSwift -s tech -l 2
```

По умолчанию ищет проект в текущей папке и пишет результат в эту же папку в файл `doc.tex`.

В LaTeX документ можно вставить просто положив рядом с щсновным `.tex` документом и вставив в нужное место:

```LaTeX
\include{doc}
```

Так же требуется пакет `longtable`. Если в вашем шаблоне этого еще нигде нет, то где-нибудь в преамбуле надо вставить:

```LaTeX
\usepackage{longtable}
```
### Параметры

- `[-s | --style] [latex | tech]` -- стиль команды самого внешнего уровня
- `[-l | --level] [1 | 2 | 3]` -- отступ в уровнях
- `[-i | --input] path/to/projectDirectory` -- путь к папке с проектом
- `[-o | --output] path/to/output.tex` -- путь к фалу, в который писать результат 
