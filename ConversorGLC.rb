require "glc/GramaticaLivreContexto"

class ConversorGLC

    #---------------------------------------------------------------------------
    # retorna um array contendo cada símbolo da cadeia w
    #---------------------------------------------------------------------------
    def self.Simbolos( w )
        return w.scan(/((?:\<[\d\w\']+\>)|[^\<])/).flatten 
    end
    
    #---------------------------------------------------------------------------
    # retorna o i-esimo simbolo da cadeia w, ou "" caso nao exista
    #---------------------------------------------------------------------------
    def self.Simbolo( w, i )
        s = Simbolos(w)
        return ( s[ i ] || "" )
    end
    
    #---------------------------------------------------------------------------
    # verifica se o simbolo s é um não terminal (deve estar delimitado por '<' e '>')
    #---------------------------------------------------------------------------
    def self.NaoTerminal?( s )
        return (/^\<[^<>]+\>$/ =~ s) != nil
    end

    #---------------------------------------------------------------------------
    # verifica se o simbolo s é um terminal
    #---------------------------------------------------------------------------
    def self.Terminal?( s )
        return( ! NaoTerminal?(s) )
    end

    
    #---------------------------------------------------------------------------
    # Exemplo para a implementacao dos algoritmos
    # O exemplo ilustra a chamada para obter o conjunto de nao-terminais e producoes.
    # Alem disso, mostra como instanciar uma nova gramatica a ser retornada pelo algoritmo
    #
    # Obs: '=begin' e '=end' na primeira coluna representam inicio e fim de comentário
    #---------------------------------------------------------------------------
=begin
    def self.EliminarXXXXXX( glc )
         n = glc.naoTerminais()
         p = glc.producoes()

         # --------------------------
         # implementacao do algoritmo
         # --------------------------

         # cria a nova gramatica a ser retornada
         glc2 = GramaticaLivreContexto.new()
         # plinha é um hash contendo todas as producoes da nova gramatica
         glc2.adicionarProducao( plinha )
         return glc2
     end    
=end
    
    #---------------------------------------------------------------------------
    # retorna uma nova GLC sem simbolos inuteis 
    #---------------------------------------------------------------------------
    def self.EliminarSimbolosInuteis( glc )
         producoes = glc.producoes() 
	#-----Identificar o alfabeto da linguagem: OK
    simbolos = []

    producoes.each do |ladoEsquerdo, ladosDireitos|
                        ladosDireitos.each do |ladoDireito|
                                simbolos |= Simbolos(ladoDireito)
                        end
                end
    simbolos.sort.each do |simbolo|
        if(NaoTerminal?(simbolo))
        simbolos.delete(simbolo)
        end
     end
     
      
     alfabeto = simbolos
     
    n0 = [] # Vetor filtrado de não-terminais
     n1 = []  # Vetor auxiliar
     loop do
                n0 |= n1                       
                producoes.each do |ladoEsquerdo, ladosDireitos|
                        ladosDireitos.each do |ladoDireito|
                                if  n0.include?(ladoDireito) || alfabeto.include?(ladoDireito)
                                        n1 |= [ladoEsquerdo]           
                                end
                        end
                end
                       
                break if n1.eql? n0
        end    
        filtroP = n0 | alfabeto

        producoes.each do |ladoEsquerdo, ladosDireitos|
                unless filtroP.include?(ladoEsquerdo)
                        producoes.delete(ladoEsquerdo) 
                end
               
                ladosDireitos.each do |ladoDireito|
                        simbolos = Simbolos(ladoDireito)
                        simbolos.each do |simbolo|
                                unless filtroP.include?(simbolo)
                                        ladosDireitos.delete(ladoDireito)
                                end    
                        end
                end
        end  
        glcNova = GramaticaLivreContexto.new()
        glcNova.adicionarProducao(producoes)
        return glcNova
    end

    #---------------------------------------------------------------------------
    # retorna uma nova GLC sem simbolos inacessiveis 
    #---------------------------------------------------------------------------
    def self.EliminarSimbolosInacessiveis( glc )
                 producoes = glc.producoes() 

         simbolos = []
      v0 =[]
      v1 = []
        v0 << producoes.keys[0]
        v1 << producoes.keys[0]
    
         loop do
                
                v0 |= v1

                       
                producoes.each do |ladoEsquerdo, ladosDireitos|
                        ladosDireitos.each do |ladoDireito|
                                if  v0.include?(ladoEsquerdo) 
                                        v1 |= Simbolos(ladoDireito)           
                                end
                        end
                end
                       
                break if v1.eql? v0
        end  
        
        producoes.each do |ladoEsquerdo, ladosDireitos|
                unless v0.include?(ladoEsquerdo)
                        producoes.delete(ladoEsquerdo) 
                end
               
                ladosDireitos.each do |ladoDireito|
                        simbolos = Simbolos(ladoDireito)
                        simbolos.each do |simbolo|
                                unless v0.include?(simbolo)
                                        ladosDireitos.delete(ladoDireito)
                                end    
                        end
                end
        end  
        glcNova = GramaticaLivreContexto.new()
        glcNova.adicionarProducao(producoes)
        return glcNova 
    end

    #---------------------------------------------------------------------------
    # retorna uma nova GLC sem producoes em vazio
    #---------------------------------------------------------------------------
    def self.EliminarProducoesEmVazio( glc )
           producoes = glc.producoes() 
    vazio =['']
    e0=[]
    e1= []
             producoes.each do |ladoEsquerdo, ladosDireitos|
                        ladosDireitos.each do |ladoDireito|
                                if  vazio.include?(ladoDireito) 
                                     e0 |= [ladoEsquerdo]
                                end
                        end
                end
    
     e1 = e0
     #guarda simbolos que leva a vazio
 loop do 
    e0 |= e1
    producoes.each do |ladoEsquerdo, ladosDireito|
        ladosDireito.each do |ladoDireito|
            simbolos = Simbolos(ladoDireito)
                simbolos.each do |simbolo|
                    if(e0.include?(simbolo))
                        e1 |= [ladoEsquerdo]
                    end
                end
        end
    end
    break if e1.eql? e0
  end  

  l1 = []
  producoes.each do |ladoEsquerdo,ladosDireito|
   #Tira simbolos que levam a vazio 
    ladosDireito.each do |ladoDireito|
        simbolos = Simbolos(ladoDireito)
        simbolos.each do |simbolo|
            if(e1.include?(simbolo))
               if(simbolo.length != 1)
                l1 = ladoDireito.sub(simbolo, "")
                ladosDireito << l1
                end
            end  
        end
    end
    ladosDireito.uniq!
   end
   p= {}
   producoes.each do |ladoEsquerdo,ladosDireito|
    if(ladoEsquerdo == producoes.keys[0])
      ladosDireito.each do |ladoDireito|
        if(ladoDireito == "")
          p = { ladoEsquerdo + 'linha' => [ladoEsquerdo, ""]  }
          
        end
      end
    end
   end
producoes.each do |ladoEsquerdo,ladosDireito|
    ladosDireito.sort.each do |ladoDireito|
        if(ladoDireito == "")
            ladosDireito.delete(ladoDireito)
        end


     end
     
   end
  producoes.merge!(p)
   glcNova = GramaticaLivreContexto.new()
        glcNova.adicionarProducao(producoes)
        return glcNova 
    end

    #---------------------------------------------------------------------------
    # retorna uma nova GLC sem producoes unitarias
    #---------------------------------------------------------------------------
    def self.EliminarProducoesUnitarias( glc )
             producoes = glc.producoes() 
    novasproducoes = producoes.clone
    p1 ={}
    l1= []
 
   novasproducoes.reverse_each do |ladoEsquerdo, ladosDireito|
   l1 |= ladosDireito
    producoes.reverse_each do |ladoEsquerdo2,ladosDireito2|
      ladosDireito2.each do |ladoDireito|
        if(ladoDireito == ladoEsquerdo)
        producoes[ladoEsquerdo2]  |= l1
        end
      end
    end
   end
producoes.each do |ladoEsquerdo,ladosDireito|
    ladosDireito.sort.each do |ladoDireito|
      if(NaoTerminal?(ladoDireito))
        ladosDireito.delete(ladoDireito)
      end
    end
   end
     glcNova = GramaticaLivreContexto.new()
        glcNova.adicionarProducao(producoes)
        return glcNova 
    end
    
    #---------------------------------------------------------------------------
    # retorna uma nova GLC sem recursoes a esquerda
    #---------------------------------------------------------------------------
    def self.EliminarRecursoesAEsquerda( glc )
         producoes = glc.producoes()
         l1= []
         p1 = {}
         p2= {}
         producoes.each do |ladoEsquerdo, ladosDireito|
          p1.merge(p2)
          ladosDireito.each do |ladoDireito|
            simbolos = Simbolos(ladoDireito)
            if(NaoTerminal?(simbolos[0]) && Terminal?(simbolos[1]) && (!simbolos[1].nil?) && (simbolos[0]== ladoEsquerdo))
            ladoDireito.slice! simbolos[0]
            ladoDireito.slice! simbolos[1]
            ladoDireito << (simbolos[0] + 'linha')
            end
            
            
          end
         end
         puts p2
         puts producoes
    end
   
    #---------------------------------------------------------------------------
    # retorna uma nova GLC na forma normal de Greibach
    #---------------------------------------------------------------------------
    def self.ConverterFNGreibach( glc )
         producoes = glc.producoes
         n1 = []
         puts 2
         producoes.each do |ladoEsquerdo, ladoDireito|
          n1 << ladoEsquerdo
         end
         puts n1
         i = n1.length
         for j in i-1..0
          producoes.each do |ladoEsquerdo,ladosDireito|
            if(ladoEsquerdo == n1[i])
              ladosDireito.each do |ladoDireito|
                simbolos = Simbolos(ladoDireito)
                if(NaoTerminal(simbolos[0]) && n1[i].include?(simbolo[0]))
                  ladosDireito.delete(ladoDireito)
                end
              end
            end
          end
         end
         puts producoes
    end
  
end