Formal Languages and Automata Project

Automata Implementation in Ruby

--------------------------------------------------------------------------------------

Enunciado:


A normalização de uma LLC pelo padrão da FNG requer, preliminarmente, a eliminação de:
a) símbolos inúteis
b) símbolos inacessíveis
c) produções unitárias
d) transições em vazio
bem como a
e) adaptação da gramática para o caso de vazio pertencer à linguagem (a produção tem de sair direto de S --> [] )

Feito isto, pode-se fazer o que mais interessa: aplicar um algoritmo de normalização GLC->FNG, cujo resultado é uma gramática que os AP's implementados em Ruby (cf. Ramos(2009)) podem processar.