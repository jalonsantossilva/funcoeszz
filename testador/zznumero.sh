#!/usr/bin/env bash

values=3
tests=(

# XXX aceitar prefixo + também?
# Sim aceita-se o prefixo, e será exibido junto ao resultado numérico.
# Ou terá um sufixo adicional 'positivo'

# número inválido ou não reconhecido
# Não exibe nada, exceto pelo código de retorno 1
#''	''	foo		t	"Número inválido 'foo'"
#''	''	a5		t	"Número inválido 'a5'"
#''	''	5a		t	"Número inválido '5a'"
''	''	foo		t	''
''	''	a5		t	''
''	''	5a		t	''

# decimais e fracionários, incompletos
# XXX Aqui devemos tentar adivinhar ou simplesmente retornar 'número inválido'?
#     Acho que quanto menos "espertezas", melhor.
# Alguns combinaçãos já advinha, mas sempre suprimindo os 0 não significativos.
#''	''	1.	t	1,00
#''	''	1,	t	1,00
#''	''	,1	t	0,1
#''	''	.	t	0
#''	''	,	t	0
#''	''	-1.	t	-1,00
#''	''	-1,	t	-1,00
#''	''	-,1	t	-0,1
#''	''	-.	t	0
#''	''	-,	t	0
''	''	1.	t	1
''	''	1,	t	1
''	''	,1	t	0,1
''	''	.	t	''
''	''	,	t	''
''	''	-1.	t	-1
''	''	-1,	t	-1
''	''	-,1	t	-0,1
''	''	+1.	t	+1
''	''	+1,	t	+1
''	''	+,1	t	+0,1
''	''	-.	t	''
''	''	-,	t	''


### Sem argumentos, formata no padrão brasileiro: 1.234.567,89
## Mesmo caso, sempre suprimindo os zeros não significativos.
# zero
#''	''	0		t	0
#''	''	0,00		t	0,00
#''	''	0,0000		t	0,0000		# XXX o certo é manter as casas ou deixar 2?
''	''	0		t	0
''	''	0,00		t	0
''	''	0,0000		t	0

# decimais positivos
''	''	1		t	1
''	''	12		t	12
''	''	123		t	123
''	''	1234		t	1.234
''	''	12345		t	12.345
''	''	123456		t	123.456
''	''	1234567		t	1.234.567
''	''	12345678	t	12.345.678
''	''	123456789	t	123.456.789
''	''	1234567890	t	1.234.567.890
# decimais negativos
''	''	-1		t	-1
''	''	-12		t	-12
''	''	-123		t	-123
''	''	-1234		t	-1.234
''	''	-12345		t	-12.345
''	''	-123456		t	-123.456
''	''	-1234567	t	-1.234.567
''	''	-12345678	t	-12.345.678
''	''	-123456789	t	-123.456.789
''	''	-1234567890	t	-1.234.567.890
# fracionários positivos (00)
# sempre suprimindo os zeros não significativos.
#''	''	1,00		t	1,00
#''	''	12,00		t	12,00
#''	''	123,00		t	123,00
#''	''	1234,00		t	1.234,00
#''	''	12345,00	t	12.345,00
#''	''	123456,00	t	123.456,00
#''	''	1234567,00	t	1.234.567,00
#''	''	12345678,00	t	12.345.678,00
#''	''	123456789,00	t	123.456.789,00
#''	''	1234567890,00	t	1.234.567.890,00
''	''	1,00		t	1
''	''	12,00		t	12
''	''	123,00		t	123
''	''	1234,00		t	1.234
''	''	12345,00	t	12.345
''	''	123456,00	t	123.456
''	''	1234567,00	t	1.234.567
''	''	12345678,00	t	12.345.678
''	''	123456789,00	t	123.456.789
''	''	1234567890,00	t	1.234.567.890
# fracionários positivos (uma casa)
''	''	1,1		t	1,1                    # XXX o certo é deixar 1 ou 2?
''	''	12,1		t	12,1
''	''	123,1		t	123,1
''	''	1234,1		t	1.234,1
''	''	12345,1		t	12.345,1
''	''	123456,1	t	123.456,1
''	''	1234567,1	t	1.234.567,1
''	''	12345678,1	t	12.345.678,1
''	''	123456789,1	t	123.456.789,1
''	''	1234567890,1	t	1.234.567.890,1
# fracionários positivos (duas casas)
''	''	1,12		t	1,12
''	''	12,12		t	12,12
''	''	123,12		t	123,12
''	''	1234,12		t	1.234,12
''	''	12345,12	t	12.345,12
''	''	123456,12	t	123.456,12
''	''	1234567,12	t	1.234.567,12
''	''	12345678,12	t	12.345.678,12
''	''	123456789,12	t	123.456.789,12
''	''	1234567890,12	t	1.234.567.890,12
# fracionários positivos (muitas casas)
''	''	1,123456789		t	1,123456789           # XXX o certo é manter as casas ou deixar 2?
''	''	12,123456789		t	12,123456789
''	''	123,123456789		t	123,123456789
''	''	1234,123456789		t	1.234,123456789
''	''	12345,123456789		t	12.345,123456789
''	''	123456,123456789	t	123.456,123456789
''	''	1234567,123456789	t	1.234.567,123456789
''	''	12345678,123456789	t	12.345.678,123456789
''	''	123456789,123456789	t	123.456.789,123456789
''	''	1234567890,123456789	t	1.234.567.890,123456789
# fracionários negativos (00)
# sempre suprimindo os zeros não significativos.
#''	''	-1,00		t	-1,00
#''	''	-12,00		t	-12,00
#''	''	-123,00		t	-123,00
#''	''	-1234,00	t	-1.234,00
#''	''	-12345,00	t	-12.345,00
#''	''	-123456,00	t	-123.456,00
#''	''	-1234567,00	t	-1.234.567,00
#''	''	-12345678,00	t	-12.345.678,00
#''	''	-123456789,00	t	-123.456.789,00
#''	''	-1234567890,00	t	-1.234.567.890,00
''	''	-1,00		t	-1
''	''	-12,00		t	-12
''	''	-123,00		t	-123
''	''	-1234,00	t	-1.234
''	''	-12345,00	t	-12.345
''	''	-123456,00	t	-123.456
''	''	-1234567,00	t	-1.234.567
''	''	-12345678,00	t	-12.345.678
''	''	-123456789,00	t	-123.456.789
''	''	-1234567890,00	t	-1.234.567.890
# fracionários negativos (uma casa)
''	''	-1,1		t	-1,1                    # XXX o certo é deixar 1 ou 2?
''	''	-12,1		t	-12,1
''	''	-123,1		t	-123,1
''	''	-1234,1		t	-1.234,1
''	''	-12345,1	t	-12.345,1
''	''	-123456,1	t	-123.456,1
''	''	-1234567,1	t	-1.234.567,1
''	''	-12345678,1	t	-12.345.678,1
''	''	-123456789,1	t	-123.456.789,1
''	''	-1234567890,1	t	-1.234.567.890,1
# fracionários negativos (duas casas)
''	''	-1,12		t	-1,12
''	''	-12,12		t	-12,12
''	''	-123,12		t	-123,12
''	''	-1234,12	t	-1.234,12
''	''	-12345,12	t	-12.345,12
''	''	-123456,12	t	-123.456,12
''	''	-1234567,12	t	-1.234.567,12
''	''	-12345678,12	t	-12.345.678,12
''	''	-123456789,12	t	-123.456.789,12
''	''	-1234567890,12	t	-1.234.567.890,12
# fracionários negativos (muitas casas)
''	''	-1,123456789		t	-1,123456789          # XXX o certo é manter as casas ou deixar 2?
''	''	-12,123456789		t	-12,123456789
''	''	-123,123456789		t	-123,123456789
''	''	-1234,123456789		t	-1.234,123456789
''	''	-12345,123456789	t	-12.345,123456789
''	''	-123456,123456789	t	-123.456,123456789
''	''	-1234567,123456789	t	-1.234.567,123456789
''	''	-12345678,123456789	t	-12.345.678,123456789
''	''	-123456789,123456789	t	-123.456.789,123456789
''	''	-1234567890,123456789	t	-1.234.567.890,123456789
# decimais e fracionários, já pontuados (não altera nada)
''	''	1.234			t	1.234
''	''	12.345			t	12.345
''	''	123.456			t	123.456
''	''	1.234.567		t	1.234.567
''	''	12.345.678		t	12.345.678
''	''	123.456.789		t	123.456.789
''	''	1.234.567.890		t	1.234.567.890
''	''	-1.234			t	-1.234
''	''	-12.345			t	-12.345
''	''	-123.456		t	-123.456
''	''	-1.234.567		t	-1.234.567
''	''	-12.345.678		t	-12.345.678
''	''	-123.456.789		t	-123.456.789
''	''	-1.234.567.890		t	-1.234.567.890
''	''	1.234,12		t	1.234,12
''	''	12.345,12		t	12.345,12
''	''	123.456,12		t	123.456,12
''	''	1.234.567,12		t	1.234.567,12
''	''	12.345.678,12		t	12.345.678,12
''	''	123.456.789,12		t	123.456.789,12
''	''	1.234.567.890,12	t	1.234.567.890,12
''	''	-1.234,12		t	-1.234,12
''	''	-12.345,12		t	-12.345,12
''	''	-123.456,12		t	-123.456,12
''	''	-1.234.567,12		t	-1.234.567,12
''	''	-12.345.678,12		t	-12.345.678,12
''	''	-123.456.789,12		t	-123.456.789,12
''	''	-1.234.567.890,12	t	-1.234.567.890,12


#########################################################################

### Mesmos testes, agora com a opção -m

# Nota: para números monetários negativos, estes são os padrões utilizados:
#
# Google Docs: -R$ 1,23
# LibreOffice: -R$ 1,23
# Excel      : -R$ 1,23
# Numbers    : -R$1,23

# zero
''	-m	0		t	"R$ 0,00"
''	-m	0,00		t	"R$ 0,00"
''	-m	0,0000		t	"R$ 0,00"

# decimais positivos
''	-m	1		t	"R$ 1,00"
''	-m	12		t	"R$ 12,00"
''	-m	123		t	"R$ 123,00"
''	-m	1234		t	"R$ 1.234,00"
''	-m	12345		t	"R$ 12.345,00"
''	-m	123456		t	"R$ 123.456,00"
''	-m	1234567		t	"R$ 1.234.567,00"
''	-m	12345678	t	"R$ 12.345.678,00"
''	-m	123456789	t	"R$ 123.456.789,00"
''	-m	1234567890	t	"R$ 1.234.567.890,00"
# decimais negativos
''	-m	-1		t	"-R$ 1,00"
''	-m	-12		t	"-R$ 12,00"
''	-m	-123		t	"-R$ 123,00"
''	-m	-1234		t	"-R$ 1.234,00"
''	-m	-12345		t	"-R$ 12.345,00"
''	-m	-123456		t	"-R$ 123.456,00"
''	-m	-1234567	t	"-R$ 1.234.567,00"
''	-m	-12345678	t	"-R$ 12.345.678,00"
''	-m	-123456789	t	"-R$ 123.456.789,00"
''	-m	-1234567890	t	"-R$ 1.234.567.890,00"
# fracionários positivos (00)
''	-m	1,00		t	"R$ 1,00"
''	-m	12,00		t	"R$ 12,00"
''	-m	123,00		t	"R$ 123,00"
''	-m	1234,00		t	"R$ 1.234,00"
''	-m	12345,00	t	"R$ 12.345,00"
''	-m	123456,00	t	"R$ 123.456,00"
''	-m	1234567,00	t	"R$ 1.234.567,00"
''	-m	12345678,00	t	"R$ 12.345.678,00"
''	-m	123456789,00	t	"R$ 123.456.789,00"
''	-m	1234567890,00	t	"R$ 1.234.567.890,00"
# fracionários positivos (uma casa)
''	-m	1,1		t	"R$ 1,10"
''	-m	12,1		t	"R$ 12,10"
''	-m	123,1		t	"R$ 123,10"
''	-m	1234,1		t	"R$ 1.234,10"
''	-m	12345,1		t	"R$ 12.345,10"
''	-m	123456,1	t	"R$ 123.456,10"
''	-m	1234567,1	t	"R$ 1.234.567,10"
''	-m	12345678,1	t	"R$ 12.345.678,10"
''	-m	123456789,1	t	"R$ 123.456.789,10"
''	-m	1234567890,1	t	"R$ 1.234.567.890,10"
# fracionários positivos (duas casas)
''	-m	1,12		t	"R$ 1,12"
''	-m	12,12		t	"R$ 12,12"
''	-m	123,12		t	"R$ 123,12"
''	-m	1234,12		t	"R$ 1.234,12"
''	-m	12345,12	t	"R$ 12.345,12"
''	-m	123456,12	t	"R$ 123.456,12"
''	-m	1234567,12	t	"R$ 1.234.567,12"
''	-m	12345678,12	t	"R$ 12.345.678,12"
''	-m	123456789,12	t	"R$ 123.456.789,12"
''	-m	1234567890,12	t	"R$ 1.234.567.890,12"
# fracionários positivos (muitas casas)
''	-m	1,123456789		t	"R$ 1,12"
''	-m	12,123456789		t	"R$ 12,12"
''	-m	123,123456789		t	"R$ 123,12"
''	-m	1234,123456789		t	"R$ 1.234,12"
''	-m	12345,123456789		t	"R$ 12.345,12"
''	-m	123456,123456789	t	"R$ 123.456,12"
''	-m	1234567,123456789	t	"R$ 1.234.567,12"
''	-m	12345678,123456789	t	"R$ 12.345.678,12"
''	-m	123456789,123456789	t	"R$ 123.456.789,12"
''	-m	1234567890,123456789	t	"R$ 1.234.567.890,12"
# fracionários negativos (00)
''	-m	-1,00		t	"-R$ 1,00"
''	-m	-12,00		t	"-R$ 12,00"
''	-m	-123,00		t	"-R$ 123,00"
''	-m	-1234,00	t	"-R$ 1.234,00"
''	-m	-12345,00	t	"-R$ 12.345,00"
''	-m	-123456,00	t	"-R$ 123.456,00"
''	-m	-1234567,00	t	"-R$ 1.234.567,00"
''	-m	-12345678,00	t	"-R$ 12.345.678,00"
''	-m	-123456789,00	t	"-R$ 123.456.789,00"
''	-m	-1234567890,00	t	"-R$ 1.234.567.890,00"
# fracionários negativos (uma casa)
''	-m	-1,1		t	"-R$ 1,10"
''	-m	-12,1		t	"-R$ 12,10"
''	-m	-123,1		t	"-R$ 123,10"
''	-m	-1234,1		t	"-R$ 1.234,10"
''	-m	-12345,1	t	"-R$ 12.345,10"
''	-m	-123456,1	t	"-R$ 123.456,10"
''	-m	-1234567,1	t	"-R$ 1.234.567,10"
''	-m	-12345678,1	t	"-R$ 12.345.678,10"
''	-m	-123456789,1	t	"-R$ 123.456.789,10"
''	-m	-1234567890,1	t	"-R$ 1.234.567.890,10"
# fracionários negativos (duas casas)
''	-m	-1,12		t	"-R$ 1,12"
''	-m	-12,12		t	"-R$ 12,12"
''	-m	-123,12		t	"-R$ 123,12"
''	-m	-1234,12	t	"-R$ 1.234,12"
''	-m	-12345,12	t	"-R$ 12.345,12"
''	-m	-123456,12	t	"-R$ 123.456,12"
''	-m	-1234567,12	t	"-R$ 1.234.567,12"
''	-m	-12345678,12	t	"-R$ 12.345.678,12"
''	-m	-123456789,12	t	"-R$ 123.456.789,12"
''	-m	-1234567890,12	t	"-R$ 1.234.567.890,12"
# fracionários negativos (muitas casas)
''	-m	-1,123456789		t	"-R$ 1,12"
''	-m	-12,123456789		t	"-R$ 12,12"
''	-m	-123,123456789		t	"-R$ 123,12"
''	-m	-1234,123456789		t	"-R$ 1.234,12"
''	-m	-12345,123456789	t	"-R$ 12.345,12"
''	-m	-123456,123456789	t	"-R$ 123.456,12"
''	-m	-1234567,123456789	t	"-R$ 1.234.567,12"
''	-m	-12345678,123456789	t	"-R$ 12.345.678,12"
''	-m	-123456789,123456789	t	"-R$ 123.456.789,12"
''	-m	-1234567890,123456789	t	"-R$ 1.234.567.890,12"
# decimais e fracionários, já pontuados (não altera nada)
# No caso uso da opção -m, sempre será 2 casas decimais
#''	-m	1.234			t	"R$ 1.234"
#''	-m	12.345			t	"R$ 12.345"
#''	-m	123.456			t	"R$ 123.456"
#''	-m	1.234.567		t	"R$ 1.234.567"
#''	-m	12.345.678		t	"R$ 12.345.678"
#''	-m	123.456.789		t	"R$ 123.456.789"
#''	-m	1.234.567.890		t	"R$ 1.234.567.890"
#''	-m	-1.234			t	"-R$ 1.234"
#''	-m	-12.345			t	"-R$ 12.345"
#''	-m	-123.456		t	"-R$ 123.456"
#''	-m	-1.234.567		t	"-R$ 1.234.567"
#''	-m	-12.345.678		t	"-R$ 12.345.678"
#''	-m	-123.456.789		t	"-R$ 123.456.789"
#''	-m	-1.234.567.890		t	"-R$ 1.234.567.890"
''	-m	1.234			t	"R$ 1.234,00"
''	-m	12.345			t	"R$ 12.345,00"
''	-m	123.456			t	"R$ 123.456,00"
''	-m	1.234.567		t	"R$ 1.234.567,00"
''	-m	12.345.678		t	"R$ 12.345.678,00"
''	-m	123.456.789		t	"R$ 123.456.789,00"
''	-m	1.234.567.890		t	"R$ 1.234.567.890,00"
''	-m	-1.234			t	"-R$ 1.234,00"
''	-m	-12.345			t	"-R$ 12.345,00"
''	-m	-123.456		t	"-R$ 123.456,00"
''	-m	-1.234.567		t	"-R$ 1.234.567,00"
''	-m	-12.345.678		t	"-R$ 12.345.678,00"
''	-m	-123.456.789		t	"-R$ 123.456.789,00"
''	-m	-1.234.567.890		t	"-R$ 1.234.567.890,00"
''	-m	1.234,12		t	"R$ 1.234,12"
''	-m	12.345,12		t	"R$ 12.345,12"
''	-m	123.456,12		t	"R$ 123.456,12"
''	-m	1.234.567,12		t	"R$ 1.234.567,12"
''	-m	12.345.678,12		t	"R$ 12.345.678,12"
''	-m	123.456.789,12		t	"R$ 123.456.789,12"
''	-m	1.234.567.890,12	t	"R$ 1.234.567.890,12"
''	-m	-1.234,12		t	"-R$ 1.234,12"
''	-m	-12.345,12		t	"-R$ 12.345,12"
''	-m	-123.456,12		t	"-R$ 123.456,12"
''	-m	-1.234.567,12		t	"-R$ 1.234.567,12"
''	-m	-12.345.678,12		t	"-R$ 12.345.678,12"
''	-m	-123.456.789,12		t	"-R$ 123.456.789,12"
''	-m	-1.234.567.890,12	t	"-R$ 1.234.567.890,12"

# Arredondamento
''	-m	1,234			t	"R$ 1,23"
''	-m	1,235			t	"R$ 1,24"
''	-m	1,236			t	"R$ 1,24"

# opção -t
''	-t	1		t	1
''	-t	12		t	12
''	-t	123		t	123
''	-t	1234		t	'1 mil 234'
''	-t	12345		t	'12 mil 345'
''	-t	123456		t	'123 mil 456'
''	-t	1234567		t	'1 milhão 234 mil 567'
''	-t	12345678	t	'12 milhões 345 mil 678'
''	-t	123456789	t	'123 milhões 456 mil 789'
''	-t	1234567890	t	'1 bilhão 234 milhões 567 mil 890'
''	-t	12345678901	t	'12 bilhões 345 milhões 678 mil 901'
''	-t	123456789012	t	'123 bilhões 456 milhões 789 mil 12'
''	-t	1234567890123	t	'1 trilhão 234 bilhões 567 milhões 890 mil 123'
''	-t	12345678901234	t	'12 trilhões 345 bilhões 678 milhões 901 mil 234'
#''	-t	-1		t	-1
''	-t	-1		t	'1 negativo'
''	-t	+1		t	'1 positivo'
''	-t	0		t	0
''	-t	-0		t	0
''	-t	+0		t	0
''	-t	9		t	9
''	-t	10		t	10
''	-t	11		t	11
''	-t	99		t	99
''	-t	100		t	100
''	-t	101		t	101
''	-t	999		t	999
''	-t	1000		t	'1 mil'
''	-t	1001		t	'1 mil 1'
''	-t	1099		t	'1 mil 99'
''	-t	1100		t	'1 mil 100'
''	-t	1101		t	'1 mil 101'
''	-t	9999		t	'9 mil 999'
''	-t	10000		t	'10 mil'
''	-t	10001		t	'10 mil 1'
''	-t	99999		t	'99 mil 999'
''	-t	100000		t	'100 mil'
''	-t	100001		t	'100 mil 1'
''	-t	999999		t	'999 mil 999'
''	-t	1000000		t	'1 milhão'
''	-t	1100100		t	'1 milhão 100 mil 100'
''	-t	9999999		t	'9 milhões 999 mil 999'

### opção --texto
#
# Tabela padrão
''	--texto	1	t	um
''	--texto	2	t	dois
''	--texto	3	t	três
''	--texto	4	t	quatro
''	--texto	5	t	cinco
''	--texto	6	t	seis
''	--texto	7	t	sete
''	--texto	8	t	oito
''	--texto	9	t	nove
''	--texto	10	t	dez
''	--texto	11	t	onze
''	--texto	12	t	doze
''	--texto	13	t	treze
''	--texto	14	t	catorze
''	--texto	15	t	quinze
''	--texto	16	t	dezesseis
''	--texto	17	t	dezessete
''	--texto	18	t	dezoito
''	--texto	19	t	dezenove
''	--texto	20	t	vinte
''	--texto	30	t	trinta
''	--texto	40	t	quarenta
''	--texto	50	t	cinquenta
''	--texto	60	t	sessenta
''	--texto	70	t	setenta
''	--texto	80	t	oitenta
''	--texto	90	t	noventa
''	--texto	100	t	cem
''	--texto	200	t	duzentos
''	--texto	300	t	trezentos
''	--texto	400	t	quatrocentos
''	--texto	500	t	quinhentos
''	--texto	600	t	seiscentos
''	--texto	700	t	setecentos
''	--texto	800	t	oitocentos
''	--texto	900	t	novecentos
''	--texto	1.000  t  'mil'
''	--texto	1.000.000  t  'um milhão'
''	--texto	1.000.000.000  t  'um bilhão'
''	--texto	1.000.000.000.000  t  'um trilhão'
''	--texto	1.000.000.000.000.000  t  'um quadrilhão'
''	--texto	1.000.000.000.000.000.000  t  'um quintilhão'
''	--texto	1.000.000.000.000.000.000.000  t  'um sextilhão'
''	--texto	1.000.000.000.000.000.000.000.000  t  'um septilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000  t  'um octilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000  t  'um nonilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000  t  'um decilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000  t  'um undecilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um duodecilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um tredecilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um quattuordecilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um quindecilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um sexdecilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um septendecilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um octodecilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um novendecilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um vigintilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um unvigintilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um douvigintilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um tresvigintilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um quatrivigintilhão'
''	--texto	1.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'um quinquavigintilhão'
''	--texto	2.000  t  'dois mil'
''	--texto	2.000.000  t  'dois milhões'
''	--texto	2.000.000.000  t  'dois bilhões'
''	--texto	2.000.000.000.000  t  'dois trilhões'
''	--texto	2.000.000.000.000.000  t  'dois quadrilhões'
''	--texto	2.000.000.000.000.000.000  t  'dois quintilhões'
''	--texto	2.000.000.000.000.000.000.000  t  'dois sextilhões'
''	--texto	2.000.000.000.000.000.000.000.000  t  'dois septilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000  t  'dois octilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000  t  'dois nonilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000  t  'dois decilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois undecilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois duodecilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois tredecilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois quattuordecilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois quindecilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois sexdecilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois septendecilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois octodecilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois novendecilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois vigintilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois unvigintilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois douvigintilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois tresvigintilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois quatrivigintilhões'
''	--texto	2.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000  t  'dois quinquavigintilhões'
# Ordens de grandeza
''	--texto	1		t	'um'
''	--texto	12		t	'doze'
''	--texto	123		t	'cento e vinte e três'
''	--texto	1234		t	'mil duzentos e trinta e quatro'
''	--texto	12345		t	'doze mil trezentos e quarenta e cinco'
''	--texto	123456		t	'cento e vinte e três mil quatrocentos e cinquenta e seis'
''	--texto	1234567		t	'um milhão, duzentos e trinta e quatro mil quinhentos e sessenta e sete'
''	--texto	12345678	t	'doze milhões, trezentos e quarenta e cinco mil seiscentos e setenta e oito'
''	--texto	123456789	t	'cento e vinte e três milhões, quatrocentos e cinquenta e seis mil setecentos e oitenta e nove'
''	--texto	1234567890	t	'um bilhão, duzentos e trinta e quatro milhões, quinhentos e sessenta e sete mil oitocentos e noventa'
''	--texto	12345678901	t	'doze bilhões, trezentos e quarenta e cinco milhões, seiscentos e setenta e oito mil novecentos e um'
''	--texto	123456789012	t	'cento e vinte e três bilhões, quatrocentos e cinquenta e seis milhões, setecentos e oitenta e nove mil e doze'
''	--texto	1234567890123	t	'um trilhão, duzentos e trinta e quatro bilhões, quinhentos e sessenta e sete milhões, oitocentos e noventa mil cento e vinte e três'
''	--texto	12345678901234	t	'doze trilhões, trezentos e quarenta e cinco bilhões, seiscentos e setenta e oito milhões, novecentos e um mil duzentos e trinta e quatro'
# Pontos de mudança de ordem
''	--texto	-1		t	'um negativo'
''	--texto	0		t	'zero'
''	--texto	9		t	'nove'
''	--texto	10		t	'dez'
''	--texto	11		t	'onze'
''	--texto	99		t	'noventa e nove'
''	--texto	100		t	'cem'
''	--texto	101		t	'cento e um'
''	--texto	999		t	'novecentos e noventa e nove'
''	--texto	1000		t	'mil'
''	--texto	1001		t	'mil e um'
''	--texto	1099		t	'mil e noventa e nove'
''	--texto	1100		t	'mil e cem'
''	--texto	1101		t	'mil cento e um'
''	--texto	9999		t	'nove mil novecentos e noventa e nove'
''	--texto	10000		t	'dez mil'
''	--texto	10001		t	'dez mil e um'
''	--texto	99999		t	'noventa e nove mil novecentos e noventa e nove'
''	--texto	100000		t	'cem mil'
''	--texto	100001		t	'cem mil e um'
''	--texto	999999		t	'novecentos e noventa e nove mil novecentos e noventa e nove'
''	--texto	1000000		t	'um milhão'
#''	--texto	1100100		t	'um milhão e cem mil e cem'
''	--texto	1100100		t	'um milhão, cem mil e cem' # Esse é um caso a ser pensado sobre a forma correta.
''	--texto	9999999		t	'nove milhões, novecentos e noventa e nove mil novecentos e noventa e nove'
# Exemplos do guia do Estadão
''	--texto	28		t	'vinte e oito'
''	--texto	54		t	'cinquenta e quatro'
''	--texto	348		t	'trezentos e quarenta e oito'
''	--texto	824		t	'oitocentos e vinte e quatro'
#
''	--texto	1.409		t	'mil quatrocentos e nove'
''	--texto	1.200		t	'mil e duzentos'
''	--texto	7.816		t	'sete mil oitocentos e dezesseis'
''	--texto	18.100		t	'dezoito mil e cem'
''	--texto	184.910		t	'cento e oitenta e quatro mil novecentos e dez'
#
''	--texto	142.387		t	'cento e quarenta e dois mil trezentos e oitenta e sete'
''	--texto	856.672.549	t	'oitocentos e cinquenta e seis milhões, seiscentos e setenta e dois mil quinhentos e quarenta e nove'
''	--texto	765.432.854.987	t	'setecentos e sessenta e cinco bilhões, quatrocentos e trinta e dois milhões, oitocentos e cinquenta e quatro mil novecentos e oitenta e sete'
)
. _lib