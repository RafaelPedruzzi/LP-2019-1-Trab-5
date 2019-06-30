# ---------------------------------------------------------- #
# Linguagens de Programação - Prof. Flavio Varejão - 2019-1
# Trabalho extra de implementação
#
# Aluno: Rafael Belmock Pedruzzi
#
# Linguagem: Elixir
#
# main.ex
#
# Obs: para executar:
#   > elixir main.ex
# ---------------------------------------------------------- #

### Módulo Point ###

defmodule Point do
  @moduledoc """
  Implementa calculos e estruturas para manipulação de pontos muldidimensionais.

  ## Funções
    - eucl_Dist: calcula a distância euclidiana entre dois pontos.
    - leader_Grouping: realiza o agrupamento de uma lista de pontos segundo o algorítimo do líder.
    - mass_Center: calcula o centro de massa de um grupo.
    - group_SSE: calcula o SSE de um agrupamento.
    - group_To_String: converte um agrupamento para string.
  """

  defstruct i: 0, coord: [] # estrutura do ponto

  @doc """
  Calcula a distância euclidiana entre dois pontos

  ## Parâmetros
    - ponto p1 ou lista de coordenadas de p1.
    - ponto p2 ou lista de coordenadas de p2.

  ## Retorno
    - a distancia euclidiana entre p1 e p2.

  ## Condições
    - os pontos devem ter o mesmo número de dimensões.
  """
  # Pontos como parâmetros:
  def eucl_Dist(%Point{i: _, coord: cs1}, %Point{i: _, coord: cs2}) do
    :math.sqrt(eucl_Dist(cs1, cs2))
  end
  # Lista de coordenadas como parâmetros:
  def eucl_Dist([], []), do: 0
  def eucl_Dist([x1 | xs1], [x2 | xs2]) do
    (x1 - x2) * (x1 - x2) + eucl_Dist(xs1, xs2)
  end

  @doc """
  Realiza o agrupamento de uma lista de pontos segundo o algorítimo do líder

  ## Parâmetros
    - distância limite entre um ponto e o líder de seu grupo.
    - lista de pontos.

  ## Retorno
    - lista com os grupos formados sendo cada grupo uma lista de pontos (líder é o ponto na primeira posição da lista do grupo).

  ## Condições
    - os pontos devem ter o mesmo número de dimensões.
  """
  def leader_Grouping(_, []), do: []
  def leader_Grouping(dist, [head | tail]) do
    group = [head | Enum.filter(tail, fn x -> eucl_Dist(head, x) <= dist end)] # formando um grupo com o primeiro ponto da lista como líder.
    rest = Enum.filter(tail, fn x -> eucl_Dist(head, x) > dist end) # atualizando lista de pontos.
    [group | leader_Grouping(dist, rest)]
  end

  @doc """
  Calcula o centro de massa de um grupo

  ## Parâmetros
    - lista de pontos que representa o grupo.

  ## Retorno
    - ponto que representa o centro de massa do grupo.

  ## Condições
    - todos os pontos devem ter o mesmo número de dimensões.
  """
  def mass_Center(group) do
    p = Enum.map(group, fn p -> p.coord end) |>
    Enum.zip() |> # agrupando as coordenadas corespondentes de cada ponto em tuplas.
    Enum.map( &Tuple.to_list(&1)) |> # convertendo as tuplas de coordenadas para listas.
    Enum.map( &Enum.sum(&1)) |> # somando os elementos de cada lista
    Enum.map( fn x -> x / length(group) end) # dividindo cada soma pelo número de pontos.
    %Point{coord: p}
  end

  @doc """
  Calcula o SSE de um agrupamento

  ## Parâmetros
    - lista de grupos que representa o agrupamento ou um grupo e seu centro de massa.

  ## Retorno
    - valor da SSE do agrupamento.

  ## Condições
    - todos os pontos devem ter o mesmo número de dimensões.
  """
  # Agrupamento como parâmetro:
  def group_SSE([]), do: 0
  def group_SSE([group | tail]) do
    cm = mass_Center(group)
    group_SSE(group, cm) + group_SSE(tail)
  end
  # Grupo e centro de massa como parâmetros:
  def group_SSE([], _), do: 0
  def group_SSE([point | tail], cm) do
    d = eucl_Dist(point, cm)
    (d * d) + group_SSE(tail, cm)
  end

  @doc """
  Converte um agrupamento para string

  ## Parâmetros
    - uma lista de grupos ou um grupo.
  """
  # Grupo como parâmetro:
  def group_To_String([ %Point{i: i, coord: _} | [] ]), do: Integer.to_string(i)
  def group_To_String([ %Point{i: i, coord: _} | tail ]), do: Integer.to_string(i) <> " " <> group_To_String(tail)
  # Lista de grupos como parâmetro:
  def group_To_String([ pointList | [] ]), do: group_To_String(pointList)
  def group_To_String([ pointList | tail ]), do: group_To_String(pointList) <> "\n\n" <> group_To_String(tail)
end


### Módulo TrabIO ###

defmodule TrabIO do
  @moduledoc """
  Realiza o tratamento de I/O dos arquivos:
  entrada.txt, distancia.txt, result.txt e saida.txt

  ## Funções
    - read_Entry: realiza a leitura dos pontos do arquivo entrada.txt.
    - read_Dist: realiza a leitura da distância limite do arquivo distancia.txt.
    - print_Groups: imprime o agrupamento formado no arquivo saida.txt.
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

  @doc """
  Imprime o agrupamento formado no arquivo saida.txt

  ## Parâmetros
    - lista de grupos que representa o agrupamento.
  """
  def print_Groups(g), do: File.write("saida.txt", Point.group_To_String(g))

  @doc """
  Imprime o resultado do SSE do agrupamento no arquivo result.txt

  ## Parâmetros
    - valor do SSE do agrupamento.
  """
  def print_SSE(sse) do
    File.write("result.txt", :erlang.float_to_binary(sse, decimals: 4))
  end
end


### Início do programa ###

# Obtendo a lista de pontos e a distância limite dos arquivos de entrada:
p = TrabIO.read_Entry()
dist = TrabIO.read_Dist()

# Realizando o agrupamento:
groups = Point.leader_Grouping(dist, p)

# Calculando o SSE do agrupamento:
sse = Point.group_SSE(groups)

# Imprimindo os resultados:
TrabIO.print_Groups(groups)
TrabIO.print_SSE(sse)
