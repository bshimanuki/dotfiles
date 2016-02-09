syntax region texZone start='\\begin{lstlisting}' end='\\end{lstlisting}\|%stopzone\>'
syntax region texZone start=/\\lstinline\*\=\z([^\ta-zA-Z]\)/ end=/\z1\|%stopzone\>/
