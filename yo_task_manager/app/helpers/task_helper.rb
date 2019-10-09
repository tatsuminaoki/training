# frozen_string_literal: true

module TaskHelper
  def aasm_states_option
    # generates [ ['', ''], ['未着手', :not_yet], ['着手中', :on_going], ... ]
    [['', '']].concat(Task.aasm.states.map(&:name).collect {|t| [Task.human_attribute_name("aasm_state.#{t.to_s}"), t]})
  end
end
