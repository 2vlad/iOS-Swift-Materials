//: [Предыдущая страница: Решето](@previous)

//: # Поисковик

//: Допустим, у нас есть набор данных:

let names = ["Илья Ш", "Илья Н", "Петя", "Вова", "Олег", "Павел", "Василиса", "Дарья", "Дима", "Аркадий", "Аркадий 16", "Аркадий 15"]


//: Можно использовать characters view ("почти массив")

Array("Строка".characters)

//: Вот так можно поискать объекты в нашем наборе данных в самом простом случае.

func началоИ(x:String) -> Bool {
    let chars = x.characters
    return chars.first == "И"
}

func серединаЕ(x:String) -> Bool {
    let chars = x.characters
    return chars[advance(chars.startIndex, 3)] == "е"
}

серединаЕ(names[0])
серединаЕ(names[5])
names.filter(серединаЕ)

//: Напоминаем, что можно вставлять объект прямо в строку с помощью `\()`.

func привет(имя:String) -> String {
    return "Привет, \(имя)!"
}

names.map(привет)

", ".join(names)

//: Несколько строк можно соединить функцией `.join`. Она вызывается на том объекте, *который* соединяет, например на `", "`. Вообще эта функция предназначена для массивов, но она работает для строк, потому что строка это по сути массив букв.

func привет(имена:[String]) -> String {
    let длинное = ", ".join(имена)
    return привет(длинное)
}

names.sort().map(привет)

привет(names)
привет(names.sort().reverse())


//: У нас есть возможность использовать или полную форму определения функции или короткую. Короткая форма в других языках называется lambda-форма. В Swift не нужен специальный оператор для определения функции – просто фигурные скобки.

// Функция lambda эквивалентна началоИ

let lambda = { (x:String) in x.characters.first == "И" }
names.filter(lambda)

//: Самая короткая форма функции:

names.filter {
    $0.characters.first == "И"
}

//:  Сортировка по количеству символов в строке

names.sort { // да, если первый раньше второго
    $0.characters.count < $1.characters.count
}

//:  Сортировка по последнему символу в строке. Два агрумента можно называть $0 и $1

let name = "Something"
name.characters.last

names.sort { // да, если первый раньше второго
    $0.characters.last < $1.characters.last
}

//:  Сортировка по последнему символу в строке и при этом case-insensitive

names.sort { // да, если первый раньше второго
    $0.lowercaseString.characters.last < $1.lowercaseString.characters.last
}

//:  А так можно перевернуть строку

String(name.characters.reverse())

Int("0056")
Double("5.6")


/*: Поставим более сложную задачу:
 - Мы ищем не только по первой букве а по всем
 - Надо получить ответ и с результатом и с позицией буквы, то есть такого формата:
*/

let результат1: (String, Int) = ("Василиса", 2)
let результат_весь: [(String, Int)] = [("Василиса", 2), ("Василиса", 8)]



//: ## Поисковый робот
// let data = "Василиса"


func РоботА(data: String) -> [(String, Int)] {
    return data
        .lowercaseString
        .characters
        .enumerate()
        .map {
            index, char in (char, index)
        }.filter { char, index in
            char == "а"
        }.map { char, index in
            (data, index)
        }
}

РоботА("Катя")
РоботА("Тарас")
РоботА("Аня")

//: Домашнее задание: робот для поиска "е"

//: Это не так сложно как кажется: можно перейти от 👶🏾 к 💪🏾.


//: `Робот("а")` это одна функция,  `Робот("б")` это другая.

func Robot(искомая:Character) -> (String -> [(String, Int)]) {
    
    return { имя in
     
//: Функция, которую мы строим,  имеет один входной параметр `имя`.
        
        return имя

//: Который надо сначала привести к нижнему регистру.

            .lowercaseString

//: Потом превратить в набор букв.
            
            .characters
            
//: Пронумеровать, то есть создать пары в формате `(0, "В"), (1, "а"),` ...
            
            .enumerate()

//: Затем для каждой пары назвать число `индекс`, а букву `буква`.
            
            .filter { индекс, буква in

//: И оставить только пары, которые мы ищем

                буква == искомая
            }

//: А в конце вместо пары из индекса и буквы
            
            .map {индекс, буква in

//: Вернуть всю строку и индекс
                (имя, индекс)
        }
        
    }
}

names
    .map(Robot("и"))
    .reduce([], combine: +)



//: ## MapReduce

//: Чтобы получить результат в виде списка, надо применить робота к каждому элементу массива, а затем собрать результаты. Например, функцией `.join`.

[].join(names.map(Robot("а")))


//: Операция сбора результатов обобщенно называется `.reduce` (например, `.join` - это частный случай для операции сложения)

names.map(Robot("л")).reduce([], combine: +)

//: Представьте себе, что names содержит 1 000 000 элементов, и робот – программа, которая параллельно выполняется на 1 000 000 компьютеров. По мере поступления данных, они собираются с помощью reduce. Получается [MapReduce](https://en.wikipedia.org/wiki/MapReduce)!

