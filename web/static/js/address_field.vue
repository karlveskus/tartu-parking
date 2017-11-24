<template>
    <div>
        <input type="text" placeholder="Enter parking address here"/>
        <button>Search</button>
    </div>
</template>

<script>
    export default {}
</script>

<style scoped>
    div {
        padding: 10px;
        position: absolute;
        width: 100%;
        z-index: 1;
    }

    input {
        -webkit-appearance: none;
        -moz-appearance: none;
        appearance: none;

        background: #fff;
        border: 1px solid #fff;
        border-radius: 0;
        box-shadow: 0 2px 6px 0px rgba(0, 0, 0, .2);
        box-sizing: border-box;
        color: #929292;
        float: left;
        font: inherit;
        margin: 0;
        outline: 0;
        padding: 10px 10px;
        width: 290px;
    }

    @media (max-width: 768px) {
        input {
            width: calc(100% - 70px);
        }
    }

    input:active, input:focus {
        border: 1px solid #4a80f5;
        border-right: 0;
    }

    input::-webkit-input-placeholder {
        color: #929292;
    }

    button {
        background: #4a80f5;
        border: 0;
        box-shadow: 0 4px 10px -2px rgba(0, 0, 0, .2);
        color: white;
        float: left;
        font-family: inherit;
        font-size: 14px;
        height: 42px;
        outline: 0;
        width: 70px;
    }

    button:hover {
        background: #4273dc;
        cursor: pointer;
    }

    button:active {
        background: #3b66c4;
    }
</style>
