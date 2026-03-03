package org.example

class App {
    val greeting: String
        get() {
            return "Hello World!"
        }
}

abstract class Duck {
    abstract fun display();
}

fun main() {
    println(App().greeting)
}
