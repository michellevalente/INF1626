$: << File.dirname(__FILE__) + "/.."

require "glc/ConversorGLC"

glc1 = GramaticaLivreContexto.new()

glc1.adicionarProducao({ "<S>" => ["<A>", "<B>", "<C>"] })
glc1.adicionarProducao({ "<A>" => ["aa<A>a", "<B>", ""] })
glc1.adicionarProducao({ "<B>" => ["b<B>b", "b", "<C>"] })
glc1.adicionarProducao({ "<C>" => ["c<C>", ""] })

glc2 = ConversorGLC::EliminarProducoesUnitarias( glc1 )

puts glc2.listarProducoes

# Resultado
# <S> => aa<A>a | '' | b<B>b | b | c<C>
# <A> => aa<A>a | '' | b<B>b | b | c<C>
# <B> => b | b<B>b | c<C> | ''
# <C> => c<C> | ''
