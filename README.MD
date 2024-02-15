# Curriculum Vitae 

## Contents

* [Introduction](#introduction)
* [Instructions](#instructions)
* [Credits](#credits)

## Introduction

This is a HTML version of my Curriculum Vitae. It was inspired by [this](https://github.com/sharu725/online-cv.git) repository, but I decided to build a new version myself, giving me the opportunity to get to know Jekyll as well as give it my own twist.

## Instructions

This project can be run either by using Docker or using Bundler. However it should also work just by hosting it on Github and setting up Github Pages.

### Development

* First clone the repository:

```bash
git clone https://github.com/antiftw/cv.git
```

* Setup and run:

Either using Docker:

```bash
docker compose up
```

or Bundler (for information how to install go [here](https://bundler.io/#getting-started)):

```bash
bundle install
bundle exec jekyll serve --verbose --trace
```

* You can then find the CV at `http://localhost:4000`

### Production

Docker:

```bash
docker compose -f docker-compose-prod.yml up
```

Github Pages:
* Fork the repository.
* Go to the settings page.
* Click on `Pages` under `Code and Automation` header in the side-menu.
* Select the `main` branch under `Branch` to set it as the source and click `Save`.
* The Github pages site will now be built from the branch, give it a moment to complete.
* The site should now be available under `https://<user>.github.io/cv/`.

## Credits

- [Sharu725's online CV](https://github.com/sharu725/online-cv.git) for the inspiration of creating a HTML CV and hosting it online.
