DynamicToDo
=============

Overview
--------

DynamicToDo lets user dynamically generate a to do list.

Each time a task is entered it is given a score based upon it's importance
and urgency (and the values of the project and category it belongs to).

Then users can generate to do lists for a selected length of time, and the app will
generate a to do list with tasks that are the most effective use of that time.
The importance of a task is given a slightly greater weight than it's urgency.

Benefits of the app:

- Always up to date. Tasks and priorities change constantly, DynamicToDo can accommodate
 all changes.
 - It encourages good mental hygiene; instead of having a half finished to do list with
 overdue warnings that people feel guilty about even while not doing anything about,
 in Dynamic ToDo there is a much clearer boundary between work time and time off. My hope
 is that the model of app will also influence users' mental models.
 - helps reduce decision fatigue
 - encourages users to consider the importance and urgency of tasks. There is also a
 scatterplot of all tasks on those two axes, so users can see if they end up with
 a clump of tasks that are all very important and very urgent, and can adjust their
 planning accordingly.


Approach
--------

I have four classes: User, Category, Project and Task. The foundation of the website
is a CRUD app for each of these classes.

They have a one to many relationship in the following order: user -> category -> project -> task.
There is also a one to many relationship between user and task.

The generate algorithm currently gives a 1.5 weight to importance over urgency, but this can be easily calibrated.

For the scatterplot user information is extracted with ActiveRecord, then passed into a hidden HTML variable,
and extracted from there with Javascript and passed to D3. There is probably a better way to do that.


What I learned
------------

- It is hard to write CSS that is DRY with a well-ordered hierarchy for websites that have even a
few pages.

- D3 is awesome.

- Passing information from Ruby to Javascript is tricky.


To Be Completed for MVPv
--------

- come up with a non-placeholder product name
- when deleting categories and projects, also delete the items within
- message to user when necessary information is not entered



Future Features and Extension
-------------

- the tasks within the projects can be sequential or non-sequential (currently all tasks are
  assumed to be non-sequential).
- animation to make list items descend individually on click
