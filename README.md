# PiGallery2-mod

This is a fork from: http://bpatrik.github.io/pigallery2/

A **fast** (like faster than your PC fast) **directory-first photo gallery website**, optimised for running on low resource servers (especially on raspberry pi).

✔️ Strengths:
 * ⚡ Fast, like for real.
 * ✔️ Simple. Point to your photos folder and to a temp folder and you are good to go.

⛔ Weakness:
 * 😥 Its simple. Shows what you have that's it. No gallery changes (photo delete, rotate, enhance, tag, organize, etc), your gallery folder is read-only.
 * 📁 Optimized for galleries with <100K photos with <5k photos/folder.
      * It will work on bigger galleries, but it will start to slow down.

[You wrote about pigallery2](docs/references/README.md).

## Live Demo
Live Demo @ render: https://pigallery2.onrender.com/ 
 - the demo page **first load** might take up **30s**: the time while the free webservice boots up

![PiGallery2 - Animated gif demo](docs/demo.gif)

## Table of contents
1. [Getting started](#1-getting-started-also-works-on-raspberry-pi)
2. [Translate the page to your own language](#2-translate-the-page-to-your-own-language)
3. [Feature list](#3-feature-list)
4. [Suggest/endorse new features](#4-suggestendorse-new-features)
5. [Known errors](#5-known-errors)
6. [Credits](#6-credits) 



## 1. Getting started (also works on Raspberry Pi)

### 1.1 [Install and Run with Docker (recommended)](docker/README.md)

[Docker](https://www.docker.com/) with [docker-compose](https://docs.docker.com/compose/) is the official and recommend way of installing and running *Pigallery2*.
It contains all necessary dependencies, auto restarts on reboot, supports https, easy to upgrade to newer versions.
For configuration and docker-compose files read more [here](docker/README.md) or check all builds [here](https://hub.docker.com/r/bpatrik/pigallery2/tags/).



### 1.2 Direct Install (if you are familiar with Node.js and building npm packages from source)
As an alternative, you can also directly [install Node.js](https://www.scaler.com/topics/javascript/install-node-js/) and the app and run it natively. 
### 1.2.0 [Install Node.js](https://nodejs.org/en/download/)
Download and extract
```bash
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Full node install on raspberry pi description: https://www.w3schools.com/nodejs/nodejs_raspberrypi.asp
 
### 1.2.1 Install PiGallery2
#### 1.2.1-a Install from release

```bash
cd ~
wget https://github.com/bpatrik/pigallery2/releases/download/1.9.0/pigallery2-release.zip
unzip pigallery2-release.zip -d pigallery2
cd pigallery2
npm install
```
#### 1.2.1-b Install from source

**Note:** A build requires a machine with around 2GB or memory.


```bash
cd ~
wget https://github.com/bpatrik/pigallery2/archive/master.zip
unzip master.zip
cd pigallery2-master # enter the unzipped directory
npm install
npm run build
```

**Note**: It is recommended to create a release version with `npm run create-release` on a more powerful machine and deploy that to you server.

**Note**: you can use `npm run create-release -- --languages=fr,ro` to restrict building to the listed languages (English is added by default)

#### 1.2.2 Run PiGallery2
```bash
npm start
```
To configure it, run `PiGallery2` first to create `config.json` file, then edit it and restart.
The app has a nice UI for settings, you may use that too. 

Default user: `admin` pass: `admin`. (It is not possible to change the admin password, you need to create another user and delete the default `admin` user, see  [#220](https://github.com/bpatrik/pigallery2/issues/220))

**Note**: First run, you might have file access issues and port 80 issue, see [#115](https://github.com/bpatrik/pigallery2/issues/115).
Running `npm start -- --Server-port=8080` will start the app on port 8080 that does not require `root`
Adding read/write permissions to all files can solve the file access issue `chmod -R o-w .`, see [#98](https://github.com/bpatrik/pigallery2/issues/98).

##### 1.2.2.1 Run on startup
You can run the app up as a service to run it on startup. Read more at [#42](https://github.com/bpatrik/pigallery2/issues/42#issuecomment-458340945)

### 1.3 Advanced configuration
You can set up the app any of the following ways:
 1. Using the UI (recommended)
 2. Manually editing the `config.json`
 3. Through switches
    * Like: `node start -- --Server-port=3000 --Client-authenticationRequired=false`
    * You can check the generated `config.json` for the config hierarchy
 4. Through environmental variable
    * like set env. variable `Server-port` to `3000`   

Full list of configuration options are available at the [MANPAGE.md](MANPAGE.md).

### 1.4 Useful links/tips:

#### using nginx
It is recommended to use a reverse proxy like nginx before node
https://stackoverflow.com/questions/5009324/node-js-nginx-what-now

#### making https
With cerbot & nginx it is simple to set up secure connection. You have no excuse not doing so.
https://certbot.eff.org/

#### node install error:
If you get error during module installation, make sure you have everything to build node modules from source
```bash
apt-get install build-essential  libkrb5-dev gcc g++
```


## 2. Translate the page to your own language
1. [Install Pigallery2](#121-b-install-from-source) from source (with the release it won't work) 
2. add your language e.g: fr
   * copy `src/frontend/translate/messages.en.xlf` to `src/frontend/translate/messages.fr.xlf`
   * add the new translation to the `angular.json` `projects->pigallery2->i18n->locales` section 
3. translate the file by updating the `<target>` tags
4. test if it works:
   build and start the app
   ```bash
   npm install
   npm run build
   npm start
   ```
5. (optional) create a pull request at github to add your translation to the project.

**Note**: you can also build your own release with as described in [1.1.1-b Install from source](#121-b-install-from-source);


## 3. Feature list

See: http://bpatrik.github.io/pigallery2/

Changes in this mod: 
* Minor UI changes to gallery tiles
* Use newer Bookworm image in Dockerfile build
 

## 4. Known errors
* IOS map issue
  * Map on IOS prevents using the buttons in the image preview navigation, see #155
* Video support on weak servers (like raspberry pi) with low upload rate
  * video playback may use up too much resources and the server might not respond for a while. Enable video transcoding in the app, to transcode the videos to lover bitrate. 
* When using an Apache proxy, sub folders are not accessible
  * add `AllowEncodedSlashes On` in the configuration of the proxy

## 5. API Endpoints

* POST /pgapi/user/login 
  * "username": "your_username",
  * "password": "your_password"

* POST /pgapi/user/logout 

* GET /pgapi/gallery/content/
  * Retrieves gallery content, including images and metadata.
  * Returns a list of ContentWrapper objects, which contain image metadata and URLs.

* GET /pgapi/gallery/content/random
  * Retrieves a random image from the gallery.
  * Returns a single ContentWrapper object containing the random image's metadata and URL.

* GET /pgapi/gallery/random/
  * Retrieves a random image from the gallery (similar to the previous endpoint, but with a different path).
  * Returns a single ContentWrapper object containing the random image's metadata and URL.

* GET /gallery/?p=<image_name>
  * Retrieves a specific image from the gallery by its name.
  * Returns the image data and metadata in a ContentWrapper object.

* GET /share/:sharingKey
  * Retrieves a shared gallery or image by its sharing key.
  * Returns a SharingDTO object containing the shared content's metadata and URL.

* GET /pgapi/gallery/search
  * Searches for images in the gallery based on query parameters (e.g., keywords, tags).
  * Returns a list of SearchResultDTO objects containing the search results' metadata and URLs.

* GET /pgapi/gallery/meta
  * Retrieves metadata for a specific image or gallery.
  * Returns a MetadataDTO object containing the image or gallery's metadata.

* POST /pgapi/gallery/upload
  * Uploads a new image to the gallery.
  * Expects a multipart/form-data request with the image file and metadata.
  * Returns a ContentWrapper object containing the uploaded image's metadata and URL.

* PUT /pgapi/gallery/:image_id
  * Updates an existing image in the gallery.
  * Expects a JSON request with the updated image metadata.
  * Returns a ContentWrapper object containing the updated image's metadata and URL.

* DELETE /pgapi/gallery/:image_id
  * Deletes an image from the gallery.
  * Returns a success response if the image is deleted successfully.

* GET /pgapi/gallery/reindex
  * Reindexes the gallery content.
  * Returns a success response if the reindexing is successful.

* GET /pgapi/settings
  * Retrieves the application settings.
  * Returns a SettingsDTO object containing the application settings.

* PUT /pgapi/settings
  * Updates the application settings.
  * Expects a JSON request with the updated settings.
  * Returns a SettingsDTO object containing the updated settings.

* Authentication and Authorization
  * Many API endpoints require authentication and authorization.
  * The AuthenticationMWs middleware is used to authenticate requests.
  * The Authorise middleware is used to authorize requests based on user roles.

* Error Handling
  * The ErrorMWs middleware is used to handle errors and return error responses.
  * Error responses are returned in a ErrorDTO object containing the error message and code.