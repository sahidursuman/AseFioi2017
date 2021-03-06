######
# Implementa le seguenti funzioni come richiesto nel commento che le precede
######

# Restituisce una stringa che dice "Benvenuto"
def welcome_message
  "Benvenuto"
end

# Restituisce n! (fattoriale)
# Calcolo del fattoriale usando il metodo reduce applicato ad un array con elementi da 1 fino al numero inserito
def factorial(n)
  if n >= 1 
      return (1..n).reduce(:*)
  elsif n == 0
    return 1
  end
  return "Error"
end

# Restituisce la stringa più lunga in un array di stringhe
# Uso del metodo max_by per fare la ricerca della stringa piu' lunga nell'array di stringhe
def find_longest_string(array)
  array.max_by { | x | x.length }
end

# Restituisce true se l'array contiene altri array (es. [[1],2,3] => true)
def has_nested_array?(array)
  # controllo se un array é vuoto,
  # se non lo é cerco all'interno di ogni elemento e controllo se all'interno ci sono altri array
  found = false
  if array != nil
    array.each do |element|
      if element.is_a?(Array)
        found = true
      end
    end
  end
  return found
end

# Conta il numero di caratteri maiuscoli in una stringa
def count_upcased_letters(string)
  # per ogni carattere contenuto nella stringa controllo che sia una lettera e che sia maiuscola
  numeroUppercase = 0
  string.chars.each do |valore|
    if(valore == valore.upcase)
      if(valore >= 'A' && valore <= 'Z')
        numeroUppercase+=1
      end
    end
  end
  numeroUppercase
end

# Converte un numero in numero romano
def to_roman(n)
  # si fa uso di un'array di array, ciascuno contenente un indice dei numeri romani e i corrispondenti valori numerici
  # inserendo inoltre i casi particolari di questa numerazione ad esempio : 4,9,40...
  indice = [
    ["M", 1000], 
    ["CM", 900],
    ["D", 500],
    ["CD", 400],
    ["C", 100],
    ["XC", 90],
    ["L", 50],
    ["XL", 40],
    ["X", 10], 
    ["IX", 9],
    ["V", 5],
    ["IV", 4],
    ["I", 1], 
  ]
  # stringa vuota usata per concatenare i caratteri romani
  roman_number = ""
  indice.each do |i|
    lettera = i[0]
    valore =  i[1]
    # concateno ciascun carattere tante volte quanto e' il risultato della divisione tra il numero e il valore del carattere
    roman_number += lettera*(n / valore)
    # modifico il valore del carattere assegnandoli un nuovo valore pari al resto della divisione tra il numero e
    # il valore corrispondente al carattere
    n = n % valore
  end
  return roman_number
end

######
# Completa l'implementazione delle seguenti classi seguendo quanto
# richiesto dai commenti.
######

class Point2D
  # costruisce un punto con coordinate (x,y)
  # nota che non e' necessario nessun controllo sul tipo di x e y
  def initialize(x, y)
    @x = x
    @y = y
  end

  # la classe punto deve avere rendere accessibili gli attributi `x` e `y`
  # IN SOLA LETTURA
  attr_reader :x, :y

  # la funzione `+` riceve come argomento un oggetto Point2D e restituisce un
  # nuovo oggetto Point2D che ha come coordinate la somma delle coordinate dei
  # due oggetti. (x1 + x2, y1 + y2)
  # la funzione non deve alterare lo stato interno dell'oggetto, ma restituire
  # un nuovo oggetto
  def + (point)
    return Point2D.new(@x + point.x, @y + point.y)
  end

  # Restituisce una rappresentazione testuale dell'oggetto punto, nella forma
  # "(x,y)", senza spazi.
  # ES: siano x = 1, y = 2.345, la funzione deve restituire "(1,2.345)"
  def to_s
    "(#{@x},#{@y})"
  end
end

require 'date' # necessario per l'uso della classe Date

class Book
  attr_accessor :title, :author, :release_date, :publisher, :isbn

  # Implementa il costruttore
  # dai un'occhiata a https://robots.thoughtbot.com/ruby-2-keyword-arguments
  def initialize(title:, author:, release_date:, publisher:, isbn:)
    @title= title
    @author= author
    @release_date= release_date
    @publisher= publisher
    @isbn= isbn
    # Mi creo un hash dove tengo salvato se un valore é valido oppure no, mi servirà per la funzione error
    @control={:title=>"not valid", :author=>"not valid", :release_date=>"not valid", :publisher=>"not valid", :isbn=>"not valid"}
  end

  # requisiti perche' un libro sia considerato valido:
  # title deve essere una stringa (@title.class == String) non vuota
  # author deve essere una stringa non vuota
  # release_date deve essere un oggetto Date
  # publisher deve essere una stringa non vuota
  # isbn deve essere un Fixnum minore di 10**10 e maggiore di 10**9
  def valid?
    # Controllo di tutti i campi
    @control[:title]="valid" if (@title.is_a?(String) && !@title.empty?)
    @control[:author]="valid" if (@author.is_a?(String) && !@author.empty?)
    @control[:release_date]="valid" if (@release_date.is_a?(Date))
    @control[:publisher]="valid" if (@publisher.is_a?(String) && !@publisher.empty?)
    @control[:isbn]="valid" if (@isbn.is_a?(Fixnum) && @isbn <= 10**10 && @isbn >= 10**9)
    
    # se anche un solo campo non é valido restituisco falso
    @control.each do |key, value|
        if value != "valid"
            return false
        end
    end
    return true
  end

  # restituisce un array di simboli.
  # Se l'oggetto e' valido, restituisce un vettore vuoto
  # Se non lo e', per ogni attributo che non e' valido, la chiave per
  # quell'attributo deve essere presente nel vettore, in qualsiasi ordine.
  # esempio: title e author non sono validi, restituisce [:title, :author]
  def errors
    # ritorno solo le chiavi dei campi che non hanno passato la validazione
    return @control.keys.select { |key| @control[key] == "not valid" }
  end
end
