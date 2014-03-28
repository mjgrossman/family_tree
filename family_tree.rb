require 'pry'
require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  system "clear"
     puts "
                   Cringle━━┯━━? Raspberry
                            │
                   ┌────────┼──────────────────┐
                   │        │                  │
     Cersei━━┯━━━Robert  Stannis━━┯━━Selyse  Renly
   Lannister │     │              │ Florent
             │     │              │
   ┌────┬────┤     ├──────┐       │
   │    │    │     │      │       │
Joffrey │ Tommen  Mya   Edric  Mary
     Myrcella    Stone  Storm"

  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts 'Press a to add a family member.'
    puts 'Press c to add a child'
    puts 'Press l to access list menu'
    puts 'Press m to add who someone is married to.'
    puts 'Press d to create a divorce'
    puts 'Press s to see who someone is married to.'
    puts 'Press e to exit.'
    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'c'
      add_children
    when 'l'
      list_menu
    when 'm'
      add_marriage
    when 'd'
      divorce_menu
    when 's'
      show_marriage
    when 'e'
      exit
    end
  end
end

def divorce_menu
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => nil)
  spouse2.update(:spouse_id => nil)
  puts spouse1.name + " is now DIVORCED from " + spouse2.name + "."
end

def list_menu
  list
  puts "Enter the person's number to see all details"
  person = Person.find(gets.chomp)
  person_details(person)
# rescue
#   puts "\nInvalid entry"
#   list_menu
end

def person_details(person)
  puts "Name:  #{person.name}"
  father = Person.where(:id => person.father_id).first
  mother = Person.where(:id => person.mother_id).first
  spouse = Person.where(:id => person.spouse_id).first
  if father != nil
    puts "Parent 1:  #{father.name}"
  end
  if mother != nil
    puts "Parent 2:  #{mother.name}"
  end
  if spouse != nil
    puts "Spouse:  #{spouse.name}"
  end
  begin
    puts "Grandparents: "
    person.grandparents.each {|p| puts p.name}
  rescue
    puts "No Grandparents"
  end

  begin
    puts "Grandchilden: "
    person.grandchildren.each do |p|
      if p != nil
        puts p.name
      end
    end
  rescue
    puts "No Grandchilden"
  end

  begin
    puts "Aunts/Uncles: "
    person.aunts_uncles.each do |p|
      if p != nil
        puts p.name
      end
    end
  rescue
    puts "No Aunts or Uncles"
  end

  begin
    puts "Cousins: "
    person.cousins.each do |p|
      if p != nil || mother.mother != nil || mother.father != nil
        puts p.name
      end
    end
  rescue
    puts "No Cousins"
  end

  puts "\nPress enter to retun to main menu"
  gets.chomp
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  Person.create(:name => name)
  puts name + " was added to the family tree.\n\n"
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => spouse2.id)
  spouse2.update(:spouse_id => spouse1.id)
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def add_children
  list
  puts "What is the number of the mother?"
  parent1 = Person.find(gets.chomp)
  puts "What is the number of the father?"
  parent2 = Person.find(gets.chomp)
  puts "What is the number of the child?"
  child = Person.find(gets.chomp)
  child.update({:mother_id => parent1.id, :father_id => parent2.id})
  puts "#{Person.find(child.id).name} added as a child of #{Person.find(parent1.id).name} and #{Person.find(parent2.id).name}"
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
  puts "\n"
end

def show_marriage
  list
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  spouse = Person.find(person.spouse_id)
  puts person.name + " is married to " + spouse.name + "."
end

menu
