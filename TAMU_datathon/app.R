#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

load('merge_data.rda')
load('merge_no_ind.rda')
code <- c(0,1,2,3)
names(code) <- c("Doesn't matter", "Low Priority", "Medium Priority", "High Priority")
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("City Search Tool - Allison (Bertie) Johnson | Arjun Ravikumar | Christopher Han | John Schwenck"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            submitButton('Get Cities'),
            selectInput('education', 'Education', names(code), selected = names(code)[2]),
            selectInput('population', 'Population', names(code)),
            selectInput('median_age', 'Median Age', names(code)),
            selectInput('walk', 'Ease of Walking', names(code)),
            selectInput('bike', 'Ease of Biking', names(code)),
            selectInput('pub_trans', 'Ease of Public Transportation', names(code)),
            selectInput('wfh', 'Work From Home', names(code)),
            selectInput('religion', 'Religious Belief', names(code)),
            selectInput('weather', 'Weather', names(code)),
            selectInput('covid', 'COVID Cases/Deaths', names(code)),
            selectInput('housing', 'Housing Price', names(code)),
            selectInput('rent', 'Rent Price', names(code)),
            selectInput('air', 'Air Quality', names(code)),
            selectInput('healthcare', 'Healthcare Access', names(code)),
            selectInput('restaurant', 'Restaurants and Bars', names(code)),
            selectInput('traffic', 'Traffic', names(code))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           dataTableOutput("result")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    user_sample <- reactive({
        # c(input$education,
        #   input$population,
        #   input$median_age,
        #   input$walk,
        #   input$bike,
        #   input$pub_trans,
        #   input$wfh,
        #   input$religion,
        #   input$weather,
        #   input$covid,
        #   input$housing,
        #   input$rent,
        #   input$air,
        #   input$healthcare,
        #   input$restaurant,
        #   input$traffic
        # )
        code <- c(0,1,2,3)
        names(code) <- c("Doesn't matter", "Low Priority", "Medium Priority", "High Priority")
        c(code[input$education],
          code[input$population],
          code[input$median_age],
          code[input$walk],
          code[input$bike],
          code[input$pub_trans],
          code[input$wfh],
          code[input$religion],
          code[input$weather],
          code[input$covid],
          code[input$housing],
          code[input$rent],
          code[input$air],
          code[input$healthcare],
          code[input$restaurant],
          code[input$traffic]
          )
        # user_sample[1] = code[input$education]
        # user_sample[2] = code[input$population]
        # user_sample[3] = code[input$median_age]
        # user_sample[4] = code[input$walk]
        # user_sample[5] = code[input$bike]
        # user_sample[6] = code[input$pub_trans]
        # user_sample[7] = code[input$wfh]
        # user_sample[8] = code[input$religion]
        # user_sample[9] = code[input$weather]
        # user_sample[10] = code[input$covid]
        # user_sample[11] = code[input$housing]
        # user_sample[12] = code[input$rent]
        # user_sample[13] = code[input$air]
        # user_sample[14] = code[input$healthcare]
        # user_sample[15] = code[input$restaurant]
        # user_sample[16] = code[input$traffic]
    })    
    
    
    output$result <- renderDataTable({
        user_obs = rep(0, length(names(merge_data)))
        
        education_q_1 = c(0.2, 0.2, 0.4, 0.6, 0.8, 0.8)
        if(user_sample()[1] == 1){
            user_obs[1:6] = map2(1-education_q_1, merge_data[,1:6],
                                 ~ quantile(.y, .x)) %>% unlist %>% unname 
        } else if(user_sample()[1] == 2){
            user_obs[1:6] = map2(rep(0.5, 6), merge_data[,1:6],
                                 ~ quantile(.y, .x)) %>% unlist %>% unname
        } else if(user_sample()[1] == 3){
            user_obs[1:6] = map2(education_q_1, merge_data[,1:6],
                                 ~ quantile(.y, .x)) %>% unlist %>% unname
        }
        
        input_vars_1 = list("7"=user_sample()[3],
                            "8"=user_sample()[2],
                            "10"=case_when(user_sample()[4]<=1 & user_sample()[5]<=1 & user_sample()[6]<=1 ~ 3,
                                           user_sample()[4]==2 | user_sample()[5]==2 | user_sample()[6]==2 ~ 2,
                                           TRUE ~ 1),
                            "11"=user_sample()[6],
                            "12"=user_sample()[4],
                            "13"=user_sample()[5],
                            "14"=user_sample()[7],
                            "15"=user_sample()[16],
                            "22"=user_sample()[8],
                            "26"=user_sample()[10],
                            "34"=user_sample()[13],
                            "44"=user_sample()[14],
                            "45"=user_sample()[15],
                            "46"=user_sample()[9],
                            "47"=user_sample()[11],
                            "48"=user_sample()[12])
        
        permanent_filter = c(9, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30, 
                             31, 32, 33, 35, 36, 37, 38, 39, 40, 41, 42, 43)
        
        input_vars_q_1 = c("D", "D", "D", "D", "D", "D", "D", "I",
                           "D", "I", "D", "D", "D", "D", "I", "I")
        mirror_input_vars_1 = rep(0, length(input_vars_1))
        
        for(i in seq(length(input_vars_q_1))){
            if(input_vars_q_1[i] == "D"){
                user_obs[as.integer(names(input_vars_1)[i])] = (quantile(merge_data[,as.integer(names(input_vars_1)[i])], 
                                                                         0.25*input_vars_1[i] %>% unname %>% unlist))
            }
            else {
                mirror_input_vars_1[i] = case_when(input_vars_1[i]==1 ~ 3,
                                                   input_vars_1[i]==3 ~ 1,
                                                   TRUE ~ 2)
                user_obs[as.integer(names(input_vars_1)[i])] = quantile(merge_data[,as.integer(names(input_vars_1)[i])], 
                                                                        0.25*mirror_input_vars_1[i])
            }
        }
        
        filter_columns = permanent_filter
        for(i in seq(length(input_vars_1))){
            if(input_vars_1[i]==0){
                filter_columns = c(filter_columns, as.integer(names(input_vars_1[i])))
            }
        }
        if(user_sample()[1]==0){
            filter_columns = c(filter_columns, 1:6)
        }
        
        merge_filter = merge_data[,-filter_columns]
        user_filter = user_obs[-filter_columns]
        merge_filter["New",] = user_filter
        
        new_cl = kmeans(merge_filter, centers=20)
        new_cluster_num = new_cl$cluster[names(new_cl$cluster)=="New"]
        new_cluster_numcities = sum(new_cl$cluster==new_cluster_num)
        new_cluster_cities = as.numeric(names(new_cl$cluster[new_cl$cluster==new_cluster_num])[1:new_cluster_numcities-1])
        
        # SIMILAR CITIES PRINTED HERE
        merge %>% filter(CBSA %in% new_cluster_cities) %>% select(NAME)
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
