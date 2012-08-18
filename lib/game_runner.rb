require 'game_board'
require 'algorithms/game_status_algorithm'

class GameRunner
  attr_accessor :board

  def initialize
    @board = GameBoard.new
    @players = [ :player, :computer ]
    @game_status = GameStatusAlgorithm.new(@players)
  end

  def start
    @winner = :none
    while @winner == :none do
      perform_turn
      check_game_status
    end
    output display_board
    output display_winner
  end

  def perform_turn
    output display_board
    perform_player_action
    check_game_status
    perform_computer_action if is_ok_for_computer_to_perform_action
  end

  def is_ok_for_computer_to_perform_action
    @winner == :none
  end

  def check_game_status
    @winner = @game_status.check_status(@board)
  end

  def perform_player_action
    ask_for_player_move
    player_choice = get_choice_from_player
    @board.apply_move(:player, player_choice)
  end

  def get_choice_from_player
    valid_choice = nil
    while valid_choice.nil? do
      player_choice = input
      valid_choice = player_choice if validate_move(player_choice)
    end
    valid_choice
  end

  def perform_computer_action
    available_moves = @board.available_tiles
    @board.apply_move(:computer, available_moves[0][:square])
  end

  def output(message)
    puts message
  end

  def input
    gets.chomp
  end

  def display_board
    @board.for_display
  end

  def ask_for_player_move
    output 'Please choose your move:'
  end

  def validate_move(square)
    is_valid = is_move_valid(square)
    output "Sorry, that was an invalid choice. Please try again." unless is_valid
    return false unless is_valid

    is_available = is_move_available(square)
    output "Sorry the move has already been taken." unless is_available
    return false unless is_available

    true
  end

  def is_move_available(square)
    @board.is_tile_available(square)
  end

  def is_move_valid(square)
    @board.is_tile_valid(square)
  end

  def display_winner
    return "The #{@winner} has won the game." if @winner == :computer || @winner == :player
    return "Game was a tie." if @winner == :draw
  end
end
