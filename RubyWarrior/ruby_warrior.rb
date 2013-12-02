class Player
  DANGER = 9
  RESTED_HEALTH = 20

  # class constructor
  def initialize
    @last_health = 0
    @explored = false
  end

  def play_turn(warrior)
    # get captives/enemies ahead of warrior
    objects_ahead = warrior.look.delete_if { |space| space.empty? || space.wall? || space.stairs? }
    
    # unless there's nothing in front of the warrior ...
    unless objects_ahead.empty?
      # If Captive is the next thing ahead
      if objects_ahead[0].captive?
        # Rescue the captive if he's in front of the warrior, otherwise move forward
        warrior.feel.captive? ? warrior.rescue! : warrior.walk!
      # If Enemy is the next thing ahead
      elsif objects_ahead[0].enemy?
        # If warrior takes range damage from behind ...
        if taking_range_damage?(warrior) && enemy_behind?(warrior)
          warrior.walk!
        else
          # Unless warrior is taking range damage and his health is low ...
          unless taking_range_damage?(warrior) && in_danger?(warrior)
            # Attack the enemy if they're next to you, or shoot a bow if they're farther away
            warrior.feel.enemy? ? warrior.attack! : warrior.shoot!
          else
            # Move backwards to safety
            warrior.walk!(:backward) if warrior.feel(:backward).empty?
          end
        end
      end
    else
      # If warrior needs to rest
      if rest?(warrior)
        warrior.rest!
      # If warrior is at stairs but hasn't explored everything
      elsif warrior.feel.stairs? && not(@explored)
        warrior.pivot!
      # If  warrior is at a wall 
      elsif warrior.feel.wall?
        @explored = true
        warrior.pivot!
      # If all else fails ...
      else
        warrior.walk!
      end
    end
    # Save health at end of turn
    @last_health = warrior.health
  end

  # Return if the warrior's health has fallen below the threshold and he's not in front of an enemy
  def in_danger?(warrior)
    warrior.health <= DANGER && !warrior.feel.enemy?
  end

  # Return if the warrior's health is dropping and he's not in melee combat
  def taking_range_damage?(warrior)
    warrior.health < @last_health && warrior.feel.empty?
  end

  # Return if the enemy is within 3 spaces behind you
  def enemy_behind?(warrior)
    warrior.look(:backward).index { |space| space.enemy? } != nil
  end

  # Return whether or not the warrior should rest
  def rest?(warrior)
    warrior.health < RESTED_HEALTH 
  end
end
