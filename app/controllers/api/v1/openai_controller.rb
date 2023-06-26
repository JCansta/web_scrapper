class Api::V1::OpenaiController < ApplicationController

    before_action :set_openai_client, :set_message_and_data

    def create
        # Api::V1::MoviesController.new.scrape
        response = @client.chat(
            parameters: {
                model: "gpt-3.5-turbo", # Required.
                messages: [{ role: "user", content: @initial_message  + ai_params[:message]}], # Required.
                temperature: 0.7,
            })
        render json: { response: response.dig("choices", 0, "message", "content") }
    end

    private

    def set_openai_client
        @client ||= OpenAI::Client.new
    end

    def ai_params
        params.require(:openai).permit(:message)
    end

    def set_message_and_data
        @data = File.read("cine_colombia.json")
        @data_2 = File.read("royal.json")
        @initial_message = "Respondeme en una sola linea y evita decir que estas leyendo la informacion de un json,
        Te voy a dar en formato JSON, donde las primeras llaves son los cines y luego el formato junto con todas las funciones de
        hoy de la pelicula spiderman y quiero que respondas con esa informacion lo que pida el usuario.
        Con que la key del json contenga 2D, ya es considerado 2D o si dice Dob tambien hace referencia a doblada y sub subtitulada,
        tambien siempre la respuesta debe contener las horas de las funciones, Ahora te dejare el formato de cinecolombia:
        #{@data} y royal films #{@data_2}  y ahora la pregunta del usuario:"
    end
end