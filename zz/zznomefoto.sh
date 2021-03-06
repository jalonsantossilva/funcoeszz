# ----------------------------------------------------------------------------
# Renomeia arquivos do diretório atual, arrumando a seqüência numérica.
# Obs.: Útil para passar em arquivos de fotos baixadas de uma câmera.
# Opções: -n  apenas mostra o que será feito, não executa
#         -i  define a contagem inicial
#         -d  número de dígitos para o número
#         -p  prefixo padrão para os arquivos
# Uso: zznomefoto [-n] [-i N] [-d N] [-p TXT] arquivo(s)
# Ex.: zznomefoto -n *                        # tire o -n para renomear!
#      zznomefoto -n -p churrasco- *.JPG      # tire o -n para renomear!
#      zznomefoto -n -d 4 -i 500 *.JPG        # tire o -n para renomear!
#
# Autor: Aurelio Marinho Jargas, www.aurelio.net
# Desde: 2004-11-10
# Versão: 1
# Licença: GPL
# ----------------------------------------------------------------------------
zznomefoto ()
{
	zzzz -h nomefoto "$1" && return

	local arquivo prefixo contagem extensao nome novo nao previa
	local i=1
	local digitos=3

	# Opções de linha de comando
	while [ "${1#-}" != "$1" ]
	do
		case "$1" in
			-p)
				prefixo="$2"
				shift; shift
			;;
			-i)
				i=$2
				shift; shift
			;;
			-d)
				digitos=$2
				shift; shift
			;;
			-n)
				nao='[-n] '
				shift
			;;
			*)
				break
			;;
		esac
	done

	# Verificação dos parâmetros
	[ "$1" ] || { zztool uso nomefoto; return 1; }

	if ! zztool testa_numero "$digitos"
	then
		echo "Número inválido para a opção -d: $digitos"
		return 1
	fi
	if ! zztool testa_numero "$i"
	then
		echo "Número inválido para a opção -i: $i"
		return 1
	fi

	# Para cada arquivo que o usuário informou...
	for arquivo
	do
		# O arquivo existe?
		zztool arquivo_legivel "$arquivo" || continue

		# Componentes do nome novo
		contagem=$(printf "%0${digitos}d" $i)

		# Se tiver extensão, guarda para restaurar depois
		if zztool grep_var . "$arquivo"
		then
			extensao=".${arquivo##*.}"
		else
			extensao=
		fi

		# O nome começa com o prefixo, se informado pelo usuário
		if [ "$prefixo" ]
		then
			nome=$prefixo
		else
			# Se não tiver prefixo, usa o nome base do arquivo original,
			# sem extensão nem números no final (se houver).
			# Exemplo: DSC123.JPG -> DSC
			nome=$(echo "${arquivo%.*}" | sed 's/[0-9][0-9]*$//')
		fi

		# Compõe o nome novo e mostra na tela a mudança
		novo="$nome$contagem$extensao"
		previa="$nao$arquivo -> $novo"

		if [ "$novo" = "$arquivo" ]
		then
			# Ops, o arquivo novo tem o mesmo nome do antigo
			echo "$previa" | sed "s/^\[-n\]/[-ERRO-]/"
		else
			echo "$previa"
		fi

		# Atualiza a contagem (Ah, sério?)
		i=$((i+1))

		# Se não tiver -n, vamos renomear o arquivo
		if ! [ "$nao" ]
		then
			# Não sobrescreve arquivos já existentes
			zztool arquivo_vago "$novo" || return

			# E finalmente, renomeia
			mv -- "$arquivo" "$novo"
		fi
	done
}
