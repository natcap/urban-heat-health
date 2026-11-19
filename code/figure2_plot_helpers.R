# Extracted unchanged from equity-temp-tcc.Rmd
get_cld_letters <- function(data, yi, group_var = "Quintile") {
  
  # keep only needed columns and remove NA rows
  df0 <- data %>%
    select(all_of(c(yi, group_var))) %>%
    filter(!is.na(.data[[yi]]), !is.na(.data[[group_var]]))

  # ensure grouping is factor
  df0[[group_var]] <- factor(df0[[group_var]])

  # if fewer than 2 groups, return "a" for whatever exists
  if (nlevels(df0[[group_var]]) < 2) {
    return(data.frame(
      Quintile = levels(df0[[group_var]]),
      Letter   = "a"
    ))
  }

  
  # Run Dunn's Test (Non-parametric pairwise)
  dunn_res <- rstatix::dunn_test(df0, 
                                 formula = as.formula(paste(yi, "~", group_var)), 
                                 p.adjust.method = "bonferroni")
  
  # Format p-values for multcompView ("Group1-Group2" = p.val)
  p_values <- setNames(dunn_res$p.adj, paste(dunn_res$group1, dunn_res$group2, sep = "-"))
  
  # Convert p-values to Letters
  letters_vec <- multcompView::multcompLetters(p_values)$Letters
  
  # Return as a dataframe
  return(data.frame(
    Quintile = names(letters_vec),
    Letter   = unname(letters_vec),
    row.names = NULL
    ))
}

func_plot_cld <- function(data, data_letter) {
  p <- 
    data %>%
    ggplot(., 
           aes(x = Quintile, 
               y = .data[[yi]], 
               fill = Quintile)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    geom_boxplot(
                 outlier.shape = 1, outlier.size = 1, 
                 outlier.alpha = 0.2) + # Show outliers lightly
    
    # Add the Letters
    geom_text(data = data_letter, 
              aes(x = Quintile, y = y_pos, label = Letter), 
              vjust = 0, # Sits right on the y_pos line
              color = 'gray50',hjust = -0.2,
              size = 3, 
              fontface = "bold") +
    
    facet_wrap(
      ~Metric, scales = "free_y",
      labeller = as_labeller(label_map, default = label_value)
    ) +
    
    # Expand Y axis slightly to fit the letters
    scale_y_continuous(expand = expansion(mult = c(0.15, .2))) + # 0.15, 0.2
    
    coord_cartesian(ylim = c(lower_bound, upper_bound)) + # Zooms the view without deleting data
    
    scale_fill_brewer(palette = "Spectral", direction = -1) +
    theme_minimal(base_size = 9) +
    theme(
      legend.position = "none",
      strip.text = element_text(face = "bold", size = 8, color = "black"),
      plot.caption = element_text(size = 7, color = "grey35", hjust = 0)
    )
  
  return(p)
}


