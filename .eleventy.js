const htmlmin = require('html-minifier-terser');
const jsmin = require('terser');

module.exports = (eleventyConfig) => {
    eleventyConfig.addPassthroughCopy("./asset/");
    eleventyConfig.addPassthroughCopy("./js/");
    eleventyConfig.addPassthroughCopy("./style/")
    eleventyConfig.addPassthroughCopy("./copyright");
    eleventyConfig.addPassthroughCopy("./index.html");
    eleventyConfig.addPassthroughCopy({
        "./tools/pull-latest.sh": "./pull-latest.sh"
    });

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
            output: "dist"
        },
    };
};