# ---------------------------------------------------------- #
# Linguagens de Programação - Prof. Flavio Varejão - 2019-1
# Trabalho extra de implementação
#
# Aluno: Rafael Belmock Pedruzzi
#
# Linguagem: Elixir
# ---------------------------------------------------------- #

#import IO
#import File
#import String

### Módulo Point ###

defmodule Point do
  @moduledoc """
  Implementa calculos e estruturas para manipulação de pontos muldidimensionais.

  ## Funções
    - eucl_Dist: calcula a distância euclidiana entre dois pontos.
    - leader_Grouping: realiza o agrupamento de uma lista de pontos segundo o algorítimo do líder.
    - mass_Center: calcula o centro de massa de uma lista de pontos.
    - sse: calcula o SSE de um agrupamento.
  """
  defstruct i: 0, coord: []

  @doc """
  Calcula a distância euclidiana entre dois pontos

  ## Parâmetros
    - ponto p1
    - ponto p2

  ## Retorno
    - a distancia euclidiana entre p1 e p2.

  ## Condições
    - os pontos devem ter o mesmo número de dimensões.
  """
  def eucl_Dist(%Point{i: _, coord: cs1}, %Point{i: _, coord: cs2}) do
    :math.sqrt(eucl_Dist(cs1, cs2))
  end
  def eucl_Dist([], []), do: 0
  def eucl_Dist([x1 | xs1], [x2 | xs2]) do
    (x1 - x2) * (x1 - x2) + eucl_Dist(xs1, xs2)
  end

  @doc """
  Realiza o agrupamento de uma lista de pontos segundo o algorítimo do líder

  ## Parâmetros
    - distância limite dist.
    - lista de pontos pontos.

  ## Retorno
    - lista com os grupos formados sendo cada grupo uma lista de pontos (líder é o ponto na primeira posição da lista do grupo).

  ## Condições
    - os pontos devem ter o mesmo número de dimensões.
  """
  def leader_Grouping(_, []), do: []
  def leader_Grouping(dist, [head | tail]) do
    group = [head | Enum.filter(tail, fn x -> eucl_Dist(head, x) <= dist end)]
    rest = Enum.filter(tail, fn x -> eucl_Dist(head, x) > dist end)
    [group | leader_Grouping(dist, rest)]
  end
end

### Módulo TrabIO ###

defmodule TrabIO do
  @moduledoc """
  Realiza o tratamento de I/O dos arquivos:
  entrada.txt, distancia.txt, result.txt e saida.txt

  ## Funções
    - read_Entry: realiza a leitura dos pontos do arquivo entrada.txt.
    - read_Dist: realiza a leitura da distância limite do arquivo distancia.txt.
    - print_Group: imprime o agrupamento formado no arquivo saida.txt.
    - print_SSE: imprime o resultado do SSE do agrupamento no arquivo result.txt.
  """

  @doc """
  Lê os pontos do arquivo entrada.txt

  ## Retorno
    - uma lista de pontos numerados segundo a ordem de leitura.
  """
  def read_Entry() do
    File.stream!("entrada.txt") |> # abrindo fluxo de leitura do arquivo (por linhas).
    Stream.map( &(String.split(&1)) ) |> # convertendo as linhas em listas de strings (coordenadas).
    Enum.map( &(Enum.map( &1, fn str -> Float.parse(str) |> elem(0) end))) |> # convertendo as strings lidas para float.
    Stream.with_index(1) |> # numerando as listas segundo a ordem de leitura.
    Enum.map( fn({coordenates, index}) -> %Point{i: index, coord: coordenates} end) # gerando a lista de pontos.
  end

  @doc """
  Lê a distância limite do arquivo distancia.txt

  ## Retorno
    - a distancia limite como um float.
  """
  def read_Dist() do
    File.read!("distancia.txt") |>
    # Convertendo a string lida em float:
    Float.parse() |>
    elem(0)
  end
end

### Início do programa ###

# Obtendo a lista de pontos e a distância limite dos arquivos de entrada:
p = TrabIO.read_Entry()
dist = TrabIO.read_Dist()


Enum.map(p, fn n -> IO.inspect n end)

# Enum.each(p, fn(p) ->
#   IO.inspect p.coord, label: "#{p.i} "
#   end)

IO.inspect dist, label: "Dist = "

#IO.inspect Point.dist(hd(p), hd(tl p))

