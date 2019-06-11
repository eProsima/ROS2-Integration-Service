# SOSS system handles

In SOSS, system handles are interfaces that communicate with each other and with the system for which they have been developed. This, among some set of predetermined procedures specified in SOSS, makes possible to communicate different systems without each system knowing any other, just with a common interface.

In order to add a new system to the soss architecture, a system handle must be created to manage the commands coming from other system handles and from the core, and also to communicate with the new system.

System handles communicate with each other by callback functions. These callback functions are given to the system handles by the soss core, whose main function is to read the configuration from a YAML file and configure every system handle with its callbacks.

The workflow of the configuration part can be seen in the following UML:

![](http://www.plantuml.com/plantuml/png/ZP9lQzim4CRVwrE838O3xHSeOxGhsHnewB3ofX0midInnMJ9qvzr-VQLvDR4LaFhDxAUU-vtkfDkhQF6-LwYJd30HwrTe_yZH9dJ1diB1eKzNjq_LfiL_l8Wsixza1uG3jyGKWKJ0rKERrKWAPO7Lc-HWogfuX9McDh9dgGywLwhesYzeKvebKKhQ8LrOF9Qv1JqVeGUL0UKfsgaB3Cl0MfOXq1n73j-1pCxC2aHYkF0rz-dm-CRunL2qtOMafhocgK-wgEGaFkc_fUW92RRR0xu1ZC3r06QoxalDce1Fztj7Zu1JIVj1G_XPsh0efm_3YjuRVef5ErXZKOrnSit3fS8XLtIeaWU2QchpQyjsM-gcZo5PLSS5FxWImKYAQAc2myyeImO5mZdL_qpFTVJEZlvBBK5L_JFzOYUz7S6SexUggFEiMF3x5M5eeA_NXZW-zC0zYjsSRbAytyrhJzpknElTdeGp5ueUyV_WN72Gf5igQ4ht8Erj8KwrbulChzTZvdxwF_j6obi1-O2dlZ6CYEQY_YmOrJAXh8_-SJpfytE3H_RbyFVqI4VNPQ5NMTWyOnlGN7VonS0)

In the configuration, the core reads the configuration file and thus knows in which system handles it has to create publishers, subscribers, clients and servers. Clients and servers are not needed in FIWARE because of its way of managing communications, so the implementation of this type of communications will not be discussed in this manual.

After loading the dynamic libraries for the system handles that will be used, the core will first ask each system handle to advertise to a certain topic with a specific message type. This means that the system handle will have to hand back to the core an instance of its implementation for the class TopicPublisher, which contains the callback function that will be used to publish messages into the external system. That callback must be able to convert the message coming from the core as a generic soss message into a message that its external system understands. 

When finished with the advertise calls, the core will have a set of callbacks to publish messages to each system. Then it will give each of these callbacks to the system handles that will be using them, with a function that must be implemented inside the system handle, called `subscribe`, that will receive the topic name and type of message, together with the callback that it will have to use each time a new message arrives to the specified topic in order to send it to the correspondent system handle(s). Then that system handle must be able to subscribe to that topic in its system, and whenever a new message arrives to the topic, transform it to a soss message and send it to the correspondent systems through the callbacks.

After the configuration, the core threads each system handle, calling its “spin_once” function repeatedly. The communication between different systems is thus managed as follows:

![](http://www.plantuml.com/plantuml/png/VOyn2uCm48Nt_8h3oGuEPYobStVNWbpFO88n2IP5-kzxY1A7u9XtttiV4G6NPCW4T0cgxXUJcjzEenkiWhO2ZD2zsajAxfGiKST6SUAeIY76nNy3hDhme9_gcs0hD4ykmXr8Avhwv0EP2BKFoNY7bfaDOP8PfzP-ZcFauYcD2XVIFQ6r7wJfT9LyPPu3kGN7EmTNOfb7JkASbiMF9elp1_UtSiCV)

# Developing a new system handle

When developing a new system handle, a class must be implemented with some specific functions. The number of functions needed vary with the type of system implemented, for example, as mentioned above, FIWARE system handle will not need to use the server/client part of soss, so it will only have the functions to publish and advertise, among some common functions that must always be implemented.

A class inheriting from `soss::TopicSystem` will hold the functions and classes needed.

The first function to be implemented is `configure`, which receives from the core a list with the names of the required types that will be used in each run. The system handle can use that list to load the libraries needed to convert between soss messages and system messages, although that part isn’t needed for the FIWARE system handle, that just needs to have a generic function to put the content of the soss messages in a JSON and vice versa.

There is also a function called `okay` with which the core must be able to check if the system handle is still running properly. Another function, called `spin_once`, will have the purpose of managing the communications with the external system. In FIWARE it is not needed, but for example in ROS2 that function calls an analogue function in ROS2 to make it check if there is any new message. This function will be called repeatedly from the soss core.

The function advertise will receive a topic name and a message type, and it will have to retrieve a class called `TopicPublisher`, that must also be implemented, and that will have a function called `publish`, which will receive a soss message and transform it to a type of message that the involved system can understand, sending it to the system.

Last, there must be a function `subscribe` that will receive the topic name and type to which it has to subscribe, and a callback function, which will be one of the `publish` functions handled to the core from another system handle. That `subscribe` function must first create a subscription in its system and then store the callback in a way that it will be invoked each time a new message arrives to the corresponding topic, converting it to a soss message first.
