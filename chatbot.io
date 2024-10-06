<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Chatbot Sederhana</title>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@3.9.4/dist/full.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
</head>
<body>
    <div id="app" class="container mx-auto p-4">
        <h1 class="text-3xl font-bold mb-4">AI Chatbot Sederhana</h1>
        <div class="chat chat-start mb-4">
            <div v-for="(message, index) in messages" :key="index" :class="['chat-bubble', message.role === 'user' ? 'chat-bubble-primary' : 'chat-bubble-secondary']">
                <p><strong>{{ message.role }}:</strong> {{ message.content }}</p>
            </div>
        </div>
        <div class="join w-full">
            <input type="text" v-model="inputMessage" @keyup.enter="sendMessage" placeholder="Ketik pesan..." class="input input-bordered join-item w-full">
            <button @click="sendMessage" class="btn join-item">Kirim</button>
        </div>
    </div>

    <script type="module">
        new Vue({
            el: '#app',
            data: {
                inputMessage: '',
                messages: []
            },
            methods: {
                async sendMessage() {
                    if (this.inputMessage.trim() !== '') {
                        const userMessage = { role: "user", content: this.inputMessage };
                        this.inputMessage = '';
                        this.messages.push(userMessage);

                        const data = await generateText(this.messages);
                        this.messages.push({ role: "assistant", content: data });
                    }
                },
            }
        });

        async function generateText(messages) {
            const { HfInference } = await import('https://esm.sh/@huggingface/inference');
            const hf = new HfInference('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'); // Token baru

            const response = await hf.chatCompletion({
                model: "mistralai/Mixtral-8x7B-Instruct-v0.1",
                messages: messages,
                max_tokens: 500,
                temperature: 0.3,
                seed: 0,
            });

            return response.choices[0].message.content;
        }
    </script>
</body>
</html>
