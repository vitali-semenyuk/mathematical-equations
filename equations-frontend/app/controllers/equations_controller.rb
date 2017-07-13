require 'equations_api'

class EquationsController < ApplicationController
  def linear
  end

  def solve_linear
    @result = EquationsAPI.new(equation_params).linear

    respond_to do |format|
      format.html { render :linear }
      format.js { render :solve_equation }
    end
  end

  def quadratic
  end

  def solve_quadratic
    @result = EquationsAPI.new(equation_params).quadratic

    respond_to do |format|
      format.html { render :quadratic }
      format.js { render :solve_equation }
    end
  end

  private

  def equation_params
    %i(
      coefficient_a
      coefficient_b
      coefficient_c
    ).reduce({}) { |hash, key| hash.update(key => params[key]) }
  end
end
