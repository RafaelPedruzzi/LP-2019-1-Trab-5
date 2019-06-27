# Linguagens de Programação - Prof. Flavio Varejão - 2019-1
# Trabalho extra de implementação
#
# Aluno: Rafael Belmock Pedruzzi
# Linguagem: Elixir
#
# main.ex: módulo main

#import IO
#import File
#import String

import TrabIO

p = File.stream!("entrada.txt") |>
Stream.map( &(String.split(&1)) ) |>
#Stream.with_index(1) |>
Enum.map( &(Enum.map( &1, fn n -> Float.parse(n) |> elem(0) end)))

Enum.map(p, fn n -> IO.inspect n end)

#Enum.each(p, fn({contents, line_num}) ->
#  IO.inspect contents, label: "#{line_num} "
#  end)
