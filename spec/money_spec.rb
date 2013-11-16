#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__)

# ***************************************************************************
# *   Copyright (C) 2013 by Marek Hakala   *
# *   hakala.marek@gmail.com   *
# *
# *   Semester project for MI-RUB @ CTU FIT
# *   Topic: Bank API
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU Library General Public License as       *
# *   published by the Free Software Foundation; either version 2 of the    *
# *   License, or (at your option) any later version.                       *
# *                                                                         *
# *   This program is distributed in the hope that it will be useful,       *
# *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
# *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
# *   GNU General Public License for more details.                          *
# *                                                                         *
# *   You should have received a copy of the GNU Library General Public     *
# *   License along with this program; if not, write to the                 *
# *   Free Software Foundation, Inc.,                                       *
# *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
# ***************************************************************************/

require 'spec_helper'
require 'bigdecimal'
require_relative '../money'

describe 'Money' do
  it "Should have additive operation between Money (Equal currencies)" do
    5.times do |item|
      a = [*1..100].sample
      b = [*100..200].sample
      
      sum1 = Money.new(a+b, "CZK")
      sum2 = Money.new(b+a, "CZK")
      
      (sum1 == sum2).should be true
      (BigDecimal.new(a+b) == sum1.value).should be true     
      (BigDecimal.new(b+a) == sum2.value).should be true
    end
  end

  it "Should have additive operation with Fixnum, Float and BigDecimal" do
    5.times do |item|
      a = [*1..100].sample
      b = [*100..200].sample
      num = Money.new(a, "CZK")
      
      sum1 = num + b
      sum2 = num + b.to_f
      sum3 = num + BigDecimal.new(b)

      # Money + Fixnum
      (sum1 == Money.new(a+b, "CZK")).should be true
      # Money + Float
      (sum2 == Money.new(a.to_f+b.to_f, "CZK")).should be true
      # Money + BigDecimal
      (sum3 == Money.new(BigDecimal.new(a)+BigDecimal.new(b), "CZK")).should be true
    end
  end

  it "Should have additive operation between Money (Different currencies)" do
      cm = CurrencyMarket.new
      cm.offlineLoad "#{File.dirname(__FILE__)}/denni_kurz.txt"

      num1 = Money.new(150, "USD")
      num1.setMarket(cm)
      num2 = Money.new(300, "CZK")
      num2.setMarket(cm)
      num3 = Money.new(10, "GBP")
      num3.setMarket(cm)
      
      sNum1 = num1 + num2
      sNum2 = sNum1 + num3
      
      sumNum = num1 + num2 + num3
      (sNum2 == sumNum).should be true
  end

  it "Should have minus operation between Money (Equal currencies)" do
    5.times do |item|
      a = [*1..100].sample
      b = [*100..200].sample
      
      sum1 = Money.new(a-b, "CZK")
      sum2 = Money.new((-1)*(b-a), "CZK")
      
      (sum1 == sum2).should be true
      (BigDecimal.new(a-b) == sum1.value).should be true     
      (BigDecimal.new((-1)*(b-a)) == sum2.value).should be true
    end
  end

  it "Should have minus operation with Fixnum, Float and BigDecimal" do
    5.times do |item|
      a = [*1..100].sample
      b = [*100..200].sample
      num = Money.new(a, "CZK")
      
      sum1 = num - b
      sum2 = num - b.to_f
      sum3 = num - BigDecimal.new(b)

      # Money - Fixnum
      (sum1 == Money.new(a-b, "CZK")).should be true
      # Money - Float
      (sum2 == Money.new(a.to_f-b.to_f, "CZK")).should be true
      # Money - BigDecimal
      (sum3 == Money.new(BigDecimal.new(a)-BigDecimal.new(b), "CZK")).should be true
    end
  end

  it "Should have minus operation between Money (Different currencies)" do
      cm = CurrencyMarket.new
      cm.offlineLoad "#{File.dirname(__FILE__)}/denni_kurz.txt"

      num1 = Money.new(150, "USD")
      num1.setMarket(cm)
      num2 = Money.new(300, "CZK")
      num2.setMarket(cm)
      num3 = Money.new(10, "GBP")
      num3.setMarket(cm)
      
      sNum1 = num1 + num2
      sNum2 = sNum1 - num3
      
      sumNum = num1 + num2 - num3
      (sNum2 == sumNum).should be true
  end
  
  it "Should have correct exchange values" do
      cm = CurrencyMarket.new
      cm.offlineLoad "#{File.dirname(__FILE__)}/denni_kurz.txt"

      num = Money.new(200, "USD")
      num.setMarket(cm)
      
      (num.to_czk == Money.new(3784.2, "CZK")).should be true
      (num.to_chf == Money.new("182.151624548736462093862815884", "CHF")).should be true
      (num.to_jpy == Money.new("171.634615384615384615384615385", "JPY")).should be true
  end
  
  it "Should have correct compare method" do
      cm = CurrencyMarket.new
      cm.offlineLoad "#{File.dirname(__FILE__)}/denni_kurz.txt"

      num1 = Money.new(200, "USD")
      num1.setMarket(cm)
      num2 = Money.new(200, "CZK")
      num2.setMarket(cm)
      num3 = Money.new(200, "USD")
      num3.setMarket(cm)
      
      (num1 == num3).should be true
      (num1 != num2).should be true
      (num1 > num2).should be true
      (num1 < num2).should be false
  end

  it "Should have multiplication operation between Money (Equal currencies)" do
    5.times do |item|
      a = [*1..100].sample
      b = [*100..200].sample
      
      sum1 = Money.new(a*b, "CZK")
      sum2 = Money.new(b*a, "CZK")
      
      (sum1 == sum2).should be true
      (BigDecimal.new(a*b) == sum1.value).should be true     
      (BigDecimal.new(b*a) == sum2.value).should be true
    end
  end

  it "Should have multiplication operation with Fixnum, Float and BigDecimal" do
    5.times do |item|
      a = [*1..100].sample
      b = [*100..200].sample
      num = Money.new(a, "CZK")
      
      sum1 = num * b
      sum2 = num * b.to_f
      sum3 = num * BigDecimal.new(b)

      # Money * Fixnum
      (sum1 == Money.new(a*b, "CZK")).should be true
      # Money * Float
      (sum2 == Money.new(a.to_f*b.to_f, "CZK")).should be true
      # Money * BigDecimal
      (sum3 == Money.new(BigDecimal.new(a)*BigDecimal.new(b), "CZK")).should be true
    end
  end

  it "Should have multiplication operation between Money (Different currencies)" do
      cm = CurrencyMarket.new
      cm.offlineLoad "#{File.dirname(__FILE__)}/denni_kurz.txt"

      num1 = Money.new(150, "USD")
      num1.setMarket(cm)
      num2 = Money.new(300, "CZK")
      num2.setMarket(cm)
      num3 = Money.new(10, "GBP")
      num3.setMarket(cm)
      
      sNum1 = num1 * num2
      sNum2 = sNum1 * num3
      
      sumNum = num1 * num2 * num3
      (sNum2 == sumNum).should be true
  end
  
  it "EDUX Testcase" do
      cm = CurrencyMarket.new
      cm.offlineLoad "#{File.dirname(__FILE__)}/denni_kurz.txt"

      num1 = Money.new(1000, "USD")
      num1.setMarket(cm)

      num2 = Money.new(1000, "EUR")
      num2.setMarket(cm)
      
      (num1 == num2).should be false
      (num1 != num2).should be true
      
      num3 = Money.new(500, "USD")
      num3.setMarket(cm)
      
      num4 = Money.new(200, "USD")
      num4.setMarket(cm)
      
      num5 = Money.new(1500, "USD")
      num5.setMarket(cm)
      
      num6 = Money.new(800, "USD")
      num6.setMarket(cm)
      
      # 1000 + 500 = 1500
      ((num1 + num3) == num5).should be true
      # 1000 - 200 = 800
      ((num1 - num4) == num6).should be true
  end
  
  it "Should have method to_money" do
    m0 = "0 AUD".to_money
    m1 = "150 CZK".to_money
    m2 = "150,01234 CZK".to_money
    m3 = "150.01234 CZK".to_money
    m4 = "150 czk".to_money
    m5 = "150,01234 usd".to_money
    m6 = "150.01234 gbp".to_money
    m7 = "0.2234 gbp".to_money

    (m0 == Money.new(0, "AUD")).should be true
    (m1 == Money.new(150, "CZK")).should be true
    (m2 == Money.new(150.01234, "CZK")).should be true
    (m3 == Money.new(150.01234, "CZK")).should be true
    (m4 == Money.new(150, "CZK")).should be true
    (m5 == Money.new(150.01234, "USD")).should be true
    (m6 == Money.new(150.01234, "GBP")).should be true
    (m7 == Money.new(0.2234, "GBP")).should be true
  end
end
