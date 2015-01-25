$: << File.dirname(__FILE__) + "/.."

require "glc/ConversorGLC"

puts "Exemplo 1"
glc1 = GramaticaLivreContexto.new()
glc1.adicionarProducao({ "<S>" => ["<A><B><C>"] })
glc1.adicionarProducao({ "<A>" => ["<B><B>", ""] })
glc1.adicionarProducao({ "<B>" => ["<C><C>", "a"] })
glc1.adicionarProducao({ "<C>" => ["<A><A>", "b"] })
glc2 = ConversorGLC::EliminarProducoesEmVazio( glc1 )
puts glc2.listarProducoes

puts "Exemplo 2"
glc3 = GramaticaLivreContexto.new()
glc3.adicionarProducao({ "<S>" => ["a<B><C>"] })
glc3.adicionarProducao({ "<B>" => ["b<B>", ""] })
glc3.adicionarProducao({ "<C>" => ["c<C>c", "d", ""] })
glc4 = ConversorGLC::EliminarProducoesEmVazio( glc3 )
puts glc4.listarProducoes

# Resultado
# Exemplo 1
# <S> => <A><B><C> | <B><C> | <A><C> | <A><B> | <C> | <B> | <A>
# <A> => <B><B> | <B>
# <B> => <C><C> | a | <C>
# <C> => <A><A> | b | <A>
# <S'> => <S> | ''

# Exemplo 2
# <S> => a<B><C> | a<C> | a<B> | a
# <B> => b<B> | b
# <C> => c<C>c | d | cc