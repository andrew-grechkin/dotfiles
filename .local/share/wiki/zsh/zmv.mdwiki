# zmv

* man:
    ```bash
    man zshcontrib
    ```
* params:
    + -n: dry-run mode
    + -v: verbose
    + -w: implicitly add surrounding parenthesis in pattern
    + -W: implicitly add surrounding parenthesis on both sides
* change extention:
    ```bash
     zmv -w '**/*.txt' '$1$2.lis'
     noglob zmv -W **/*.txt **/*.lis
    ```
* rename to lower case:
    ```bash
    zmv '*' '${(L)f}'
    ```
* lower case extention:
    ```bash
    zmv '(**/)(*).(#i)jpg' '$1$2.jpg'
    ```
* capitalize first letter:
    ```bash
    zmv '([a-z])(*).txt' '${(C)1}$2.txt'
    ```
* lower case first letter if capital:
    ```bash
    zmv -w '[[:upper:]]*' '${(L)1}$2'
    ```
