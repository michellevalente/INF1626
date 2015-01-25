$: << File.dirname(__FILE__) + "/.."

require "glc/ConversorGLC"

glc1 = GramaticaLivreContexto.new()

glc1.adicionarProducao({ "<S>" => ["<A>"] })
glc1.adicionarProducao({ "<A>" => ["b<S>", "b"] })
glc1.adicionarProducao({ "<C>" => ["<A><S>", "b"] })

glc2 = ConversorGLC::EliminarSimbolosInacessiveis( glc1 )

puts glc2.listarProducoes

# Resultado
# <S> => <A>
# <A> => b<S> | b