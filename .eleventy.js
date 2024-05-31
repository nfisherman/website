require('dotenv').config();
const htmlmin = require('html-minifier-terser');
const jsmin = require('terser');

module.exports = (eleventyConfig) => {
    eleventyConfig.addPassthroughCopy("./src/css/");
    eleventyConfig.addPassthroughCopy("./src/fonts/");
    eleventyConfig.addPassthroughCopy("./src/img/");
    eleventyConfig.addPassthroughCopy("./src/js/");

    eleventyConfig.addTransform("htmlmin", (content, outputPath) => {
        if(outputPath.endsWith(".html")) {
            return htmlmin.minify(content, {
                collapseBooleanAttributes: true,
                collapseWhitespace: true,
                removeComments: true,  
                useShortDoctype: true
            }).then(contentStr => {
                return new Promise(function(resolve) {
                    resolve(
                        "<!-- HTML is minified. Clone from Github and run locally. -->\n" + 
                        "<!-- https://github.com/nfisherman/nfisherman.com -->\n" +
                        contentStr
                    );
                });
            })
        }

        return content;
    });

    return {
        dir: {
            input: "src",
        },
    };
};