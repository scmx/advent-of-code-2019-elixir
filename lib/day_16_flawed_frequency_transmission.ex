defmodule Adventofcode.Day16FlawedFrequencyTransmission do
  use Adventofcode

  alias __MODULE__.{FFT, Parser}

  def part_1(input) do
    input
    |> Parser.parse()
    |> FFT.run(100)
    |> FFT.output_digits(8)
  end

  defmodule FFT do
    @base_pattern {0, 1, 0, -1}

    @enforce_keys [:signal]
    defstruct signal: [], phase: 0

    def new(signal) do
      %FFT{signal: signal}
    end

    def output_digits(fft, size) do
      fft.signal
      |> Enum.take(size)
      |> Enum.join()
    end

    def run(%{phase: phase} = fft, phase), do: fft

    def run(%{phase: current} = fft, last_phase) when current <= last_phase do
      fft
      |> Map.put(:signal, next_phase(fft))
      |> Map.update!(:phase, &(&1 + 1))
      |> run(last_phase)
    end

    defp next_phase(fft) do
      fft
      |> pattern()
      |> Enum.map(&Enum.sum/1)
      |> Enum.map(&abs(rem(&1, 10)))
    end

    def pattern(fft) do
      0..(length(fft.signal) - 1)
      |> Enum.to_list()
      |> Enum.map(&do_pattern(fft, &1))
    end

    defp do_pattern(fft, output_index) do
      fft.signal
      |> Enum.with_index()
      |> Enum.map(fn {digit, index} -> formula(index, output_index, digit) end)
    end

    defp formula(index, output_index, digit) do
      size = tuple_size(@base_pattern)
      pattern_index = div(index + 1, output_index + 1)
      digit * elem(@base_pattern, modulo(pattern_index, size))
    end

    def modulo(dividend, divisor) do
      dividend
      |> rem(divisor)
      |> Kernel.+(divisor)
      |> rem(divisor)
    end
  end

  defmodule Parser do
    def parse(input) do
      input
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> FFT.new()
    end
  end
end
