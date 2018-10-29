---
title: gulpfile.js  
date: 2017-01-10 9:45              
tags: ['JavaScript','前端自动化']
toc: true
categories: technology

---

```
//引入gulp
var gulp = require('gulp');		//基础库
var sass = require('gulp-ruby-sass');	//sass/scss编译
var uglify = require('gulp-uglify');	//js压缩
var imagemin = require('gulp-imagemin')
var pngquant = require('imagemin-pngquant');	//图片深度压缩
var sourcemaps = require('gulp-sourcemaps');	//来源地图
//引入gulp插件
var livereload = require('gulp-livereload');	//网页自动刷新(服务器控制客户端同步刷新)
var webserver = require('gulp-webserver');		//本地服务
var rename = require('gulp-rename'); 			// 文件重命名
var changed = require('gulp-changed'); // 只操作有过修改的文件
var concat = require('gulp-concat');	//文件合并
var clean = require('gulp-clean');		//文件清理
var minifyCss = require('gulp-minify-css'); // CSS压缩
var postcss = require('gulp-postcss');	//
var cssnano = require('gulp-cssnano');	//用来压缩CSS的
var autoprefixer = require('autoprefixer');	//自动添加CSS3浏览器前缀


//注册web服务任务
gulp.task('webserver', function(){
	gulp.src('./dist')	//服务器目录(./代表根目录)
	.pipe(webserver({	//运行gulp-webserver
		livereload:true,	//启动LiveReload
		open:'views/app/index.html'			//服务器启动时自动打开网页
		port: 8877,
	}));
});

//注册自动刷新任务
//监听任务
gulp.task('watch',function(){
	// 监听 html
	gulp.watch('src/**/*.html', ['html'])
	// 监听 sacss
	gulp.watch('src/sass/*.sass', ['sass']);
	// 监听 images
	gulp.watch('src/images/**/*.{png,jpg,gif,svg}', ['images']);
	// 监听 js
	gulp.watch('src/js/*.js', ['script']);
});

//sass编译任务
gulp.task('sass', function(){
	//插件提供4种输出格式： 
	//nested：嵌套缩进的css代码，它是默认值
	//expanded：没有缩进的、扩展的css代码。 
	//compact：简洁格式的css代码。
	//compressed：压缩后的css代码。
	return sass('src/sass/*.sass', {style:'compact'})	
	//指示源文件路径、并进行文件匹配(style: 'compressed'表示输出格式)
		.on('error', function(err){
			console.log('编译sass出错%s', err.message);
		})
		/*.pipe(postcss([autoprefixer({
			browsers:['last 2 versions'],	
			//主流浏览器的最新两个版本
			//cascade:false	//是否美化属性值
		})]))*/
		//.pipe(cssnano())
		.pipe(gulp.dest('src/css'));	
		//输出路径
});

//CSS的压缩配置任务
gulp.task('minify-css', () => {
	return gulp.src('src/sass/*.css')
		.pipe(gulp.dest('dist/css'))	
})

//添加CSS3前缀任务
gulp.task('css3-prefix',() =>{
	gulp.src('src/css/*.css')
		.pipe(postcss([autoprefixer({
			 browsers: ['last 5 versions'],	
			 //主流浏览器的最新两个版本
			 cascade:true,	
			 //是否美化属性值
			 remove:true	
			 //去掉不必要的前缀
		})]))
		.pipe(gulp.dest('dist/css'));
});

//gulp脚本压缩任务
gulp.task('script', () => {
	return gulp.src('src/js/**/*.js')
		//指明源文件路径、并进行文件匹配
		//gulp.src(['src/js/*.js','!*.min.js'])
		//配置源文件路径、并进行文件匹配，排除.min.js后缀的文件
		//.pipe(sourcemaps.init())
		//执行sourcemaps
		//.pipe(changed('dist/js',{extension:'.js'}))
		// 对比文件是否有过改动（此处填写的路径和输出路径保持一致）,只要有一个文件变化整个目录都会重新编译
		//.pipe(rename({suffix:'.min'}))	//后添加的配置，进行重命名
		.pipe(uglify({preserveComments:'some'}))
		//使用uglify进行压缩，并保留部分注释
		//.pipe(sourcemaps.write('maps'))	//地图输出路径(存放的位置)
		.pipe(gulp.dest('dist/js'));	//输出路径
});

//gulp文件合并任务
gulp.task('concat', () => {
	gulp.src('dist/js/*.min.js')
	//要合并的文件
	.pipe(concat('libs.js'))
	//合并成libs.js
	.pipe(gulp.dest('dist/js'));
})

gulp.task('clean', () => {
	gulp.src(['dist/js/*.min.js'], {read:false})
	.pipe(clean());
});

//gulp图片压缩任务
gulp.task('images', () => {
	return gulp.src('src/images/**/*.{png,jpg,gif}')
		//指明源文件路径、并进行文件匹配
		.pipe(imagemin({
			progressive:true,	
			//无损压缩JPG图片
			svgoPlugins:[{removeViewBox:false}],	
			//不移除svg的viewbox属性
			use:[pngquant()]	
			//使用pngquant插件进行深度压缩
		})).pipe(gulp.dest('dist/images'));	
		////输出路径
});





//发布静态页面到dist目录中
gulp.task('html', function(){
	return gulp.src('src/**/*.html')	
	//指示文件路径、并进行文件匹配
	.pipe(gulp.dest('dist'));
	// 输出路径
});

//默认任务
gulp.task('default',['script','minify-css','html','webserver','watch']);
```



