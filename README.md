# Exercise 07: Authentication and Testing
A Flutter todo app with user login functionality.

### Name
Christian Jewel M. Pascua

### Student Number
2019-04558

### Section
D-1L

## Screenshots
<img width="204" alt="image" src="https://user-images.githubusercontent.com/64654366/203043055-e802f429-391e-4d1e-8d06-71efa5e1a54e.png">
<img width="204" alt="image" src="https://user-images.githubusercontent.com/64654366/203043110-64c03f6e-b783-4d9e-930d-f5e6e09cee3f.png">
<img width="204" alt="image" src="https://user-images.githubusercontent.com/64654366/203043192-81b4bfd0-5ca8-4bdc-8864-75ece5b2baf0.png">
<img width="204" alt="image" src="https://user-images.githubusercontent.com/64654366/203043227-54296082-f437-4957-b52d-0fab06e15c9d.png">

## Things you did in the code
I used the lab sample codes as a starter code for this exercise. I converted the textfields to textform fields and added input validation to them. In addition, I added first name and last name fields in the sign up page. I also added a feature to show firebase authentication errors in a snackbar.

## Challenges faced
I faced the most difficulty in creating automated tests for the app. I also spent some time fixing input validation in input fields. For some reason, the app is not detecting if the first name and last name fields are already filled. Fortunately, I was able to fix them eventually by using a simpler method of input validation.

## Test Cases
Happy paths:
  1. Once user launches the app, a login screen with an email field, password field, login button, and sign up button appears.
  2. Once user taps the sign up button, the sign up screen appears with a first name field, last name field, email field, password field, sign up button, and a back button.

Unhappy paths:
  1. The user taps the login button without entering any input to the email and password fields.
  2. The user taps the sign up button without entering any input to the frist name, last name, email, and password fields.

## References
https://stackoverflow.com/questions/62248134/how-can-i-postion-the-text-in-bottom-left-in-the-drawer-header-and-reduce-the-dr
https://firebase.google.com/docs/auth/web/password-auth
https://www.youtube.com/watch?v=4vKiJZNPhss
