# SourceDocsSwift

Генернирует LaTeX-таблицы всех классов, структур и их полей и методов из проекта Xcode для вставки в техническую документацию.

## Установка

```bash
brew install ilyakooo0/tap/sourceDocsSwift
```

## Использование

```bash
sourceDocsSwift -i path/to/XcodePrjectDirectory/ -o path/to/output/docs.tex 
```

По умолчанию ищет проект в текущей папке и пишет результат в эту же папку в файл `docas.tex`.

В LaTeX документ можно вставить просто положив рядом с щсновным `.tex` документом и вставив в нужное место:

```LaTeX
\include{doc}
```

Так же требуется пакет `longtable`. Если в вашем шаблоне этого еще нигде нет, то где-нибудь в преамбуле надо вставить:

```LaTeX
\usepackage{longtable}
```
