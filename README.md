# Online Movie Registration Form

A cleaned and portfolio-ready static registration form for a movie streaming account. The original project provided a simple HTML form and a thank-you page; this version preserves that flow while organizing the code into a maintainable static web structure.

## Features

- Registration form for basic account details
- Gender, phone, email, password, genre, and plan fields
- Minimal browser-side validation for required fields and matching passwords
- Thank-you confirmation page after successful form submission
- Responsive styling for desktop and mobile screens

## Tech Stack

- HTML5
- CSS3
- JavaScript

## Project Structure

```text
online-movie-registration-form/
|-- assets/
|   |-- registration-form.png
|   `-- thank-you-page.png
|-- docs/
|   `-- inferred-components.md
|-- src/
|   |-- index.html
|   |-- script.js
|   |-- styles.css
|   `-- thankyou.html
`-- README.md
```

## Setup

No build tools are required.

1. Open `src/index.html` in a browser.
2. Complete the form.
3. Submit the form to navigate to `src/thankyou.html`.

## Architecture

This is a client-only static application. The form uses native HTML validation, with a small JavaScript enhancement to verify that both password fields match before navigating to the confirmation page.

## Screenshots

Registration form:

![Registration form](assets/registration-form.png)

Successful registration page:

![Successful registration page](assets/thank-you-page.png)

## Source Notes

The source ZIP included a two-page HTML project. The embedded `.git` directory from the archive was intentionally excluded from the cleaned repository structure.
