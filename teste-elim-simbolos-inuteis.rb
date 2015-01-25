$: << File.dirname(__FILE__) + "/.."

require "glc/ConversorGLC"

glc1 = GramaticaLivreContexto.new()

glc1.adicionarProducao({ "<S>" => ["<A>", "<B>"] })
glc1.adicionarProducao({ "<A>" => ["a<B>", "b<S>", "b"] })
glc1.adicionarProducao({ "<B>" => ["<A><B>", "<B>a"] })
glc1.adicionarProducao({ "<C>" => ["<A><S>", "b"] })

glc2 = ConversorGLC::EliminarSimbolosInuteis( glc1 )

puts glc2.listarProducoes

# Resultado
# <A> => b<S> | b
# <C> => <A><S> | b
# <S> => <A>