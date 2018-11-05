---
title: React(1)之快速概览  
date: 2017-02-08     
tags: ['React','JSX']
toc: true
categories: technology

---
### 0x00 JSX 

JSX 是 JavaScriptXML 的缩写，基于ECMAScript的一种新特性（并不是一种新语言），一种定义带属性树结构（DOM结构）的语法，它并不是 XML 或者 HTML。


---
#### 基本语法
可以把 JSX 标签当做一个变量,而在 React 中，一个标签就是一个组件:

```
const div = <div>hello,world</div>;
ReactDOM.render(div, document.body);
```

> 在 JSX 中，所有标签必需严格闭合。

自定义标签首字母必需大写，而且对于标签中自定义属性,事件等命名必需使用 `camelCase` 方法:

```
const add = function () {};
<Welcome onClic={add}className="this.props.name"/>
```

JSX 语法解析规则是: 遇到 HTML 标签（以 < 开头），就用 HTML 规则解析；遇到代码块（以 { 开头），就用 JavaScript 规则解析。但并不是所有的 JavaScript 语法都能被解析，比如 `if` 语句就不可以。



##### 条件判断

如果要在 JSX 中使用条件判断，可以使用三目运算符或者使用函数。

```
<div calssName={"this.sate.isCompelte ? 'is-complete' : ''}></div>
```


##### 使用变量

```
const myName = "Jack";
function getId (props) {
    return props.id;
}
const isDiv = <div id={getid()}>{ "Your Name:" + myName}</div>
```

如上，JSX 中可以对组件中的属性使用变量或函数，这一点是不同于 HTML 的。




##### 使用 Array


```
const names = ["Alice", "Jack"];

    function ListItems (props) {
        const names = props.names;
        return (
                <ul>
                    {
                        names.map( (name) => {
                            return <li key={name.toString()}>{name}</li>;
                        })
                    }
                </ul>
        )
    }

    ReactDOM.render(
        <ListItems names={names}/>,
        document.getElementById('root')
    );
```

> 注意 <li> 标签中的 key 属性，在使用具有 Iterator 接口或者数组等源数据生成多个重复的组件时，key 属性是必须的，而且应该是唯一的，这将有利于 React 识别唯一组件进行渲染。


---
### 0x01 安装 React

一个基本的 React 应用需要 `react` 和 `react-dom` 库:

```
λ mkdir MyReact
λ npm install -y
λ  npm install react react-dom --save-dev
λ  npm install babel@5 --save-dev
```

---
### 0x01 组件和属性集

React 中可以使用函数或者类继承自 `React.Component` 来构建组件。

---
#### 函数组件

```
function Welcome (props) {
    return <h1>Hllo, {props.name}</h1>;
}

ReactDOM.render(
    <Welcome name="Jack"/>,
    document.getElementById('root')
);
```

---
#### 类组件

```
class LittleComponent extends React.Component {
    render(){
         return <div>{this.props.name}</div>
    }
}
ReactDOM.render(
    <LittleComponent name="Jack"/>,
    document.getElementById('root')
);
```

> 在 React `props` 对象是只读的， 无论是函数还是类，都不能改变自己的属性(props)，而所有 React 组件都必须像纯函数那样运行。

当然，还是有例外的，比如网络响应组件这些状态可能随时变化的组件不适用这一规则。

---
### 0x02 状态和生命周期
`state` 是只有类组件拥有的特性，`state` 状态和 `props` 属性集类似，但是 `state` 是私有的并且完全由组件控制。

`state` 存在存在于组件的生命周期之中。React 提供了两个特别的方法 `componentDidMount()` 和 `componentWillUnmout()` 作为 `lifecycle hooks` 生命周期钩子去赋予和结束生命周期。

`componentDidMount` 会在组件 `render` 之后被自动调用，而 `componentWillUnmount`会在组件被移除时自动调用。

下面是 React 官网的 example:

```
class Clock extends React.Component {

constructor(props){
    super(props);
    this.state = {date: new Date()};
}

componentDidMount () {
    this.timerId = setInterval(
        () => this.tick(),
        1000
    );
}

componentWillUnmount() {
    clearInterval(this.timerId);
}

tick (){
    this.setState({
        date: new Date()
    });
}

render(){
    return (
        <div>
            <h1>Hello,world!</h1>
            <h2>It is: {this.state.date.toLocaleTimeString()}</h2>
        </div>
    )
}
}

ReactDOM.render(
    <Clock/>,
   document.querySelector('#root')
)
```


