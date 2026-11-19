# Figure 2 only: identical score ordering, Dunn comparisons and original style.
suppressPackageStartupMessages({library(dplyr);library(tidyr);library(ggplot2)
 library(purrr);library(rstatix);library(multcompView);library(patchwork)})
d <- read.csv('data/equity/figure2_lsoa.csv')
stopifnot(nrow(d)==4835,!anyDuplicated(d$LSOA11CD),sum(is.finite(d$temp_baseline))==4831)
panels <- list()
for(outcome in c('temp_baseline','TCC')) {
 panels[[outcome]] <- local({
 yi <- outcome
 source('code/figure2_plot_helpers.R',local=TRUE)
 df_cat2 <- d %>% transmute(Metric='SVI',Quintile=factor(SVI_q,levels=paste0('Q',1:5),ordered=TRUE),value=.data[[yi]])
 names(df_cat2)[3] <- yi
 # Original viewport percentiles were pooled across five indicator panels.
 # Reproduce that finite-sample interpolation only for the display limits.
 # Tests, letters and boxplot statistics use each neighbourhood once.
 display_values <- rep(df_cat2[[yi]],each=5)
 lower_bound <- quantile(display_values,.05,na.rm=TRUE)
 upper_bound <- quantile(display_values,.95,na.rm=TRUE)
 label_map <- c(SVI='Social Vulnerability Index')
 cld_data <- df_cat2 %>% group_by(Metric) %>% nest() %>%
   mutate(cld=map(data,~get_cld_letters(.x,yi))) %>% unnest(cld) %>% select(Metric,Quintile,Letter)
 y_pos_scale <- if(yi=='temp_baseline') 1.005 else 1.05
 y_positions <- df_cat2 %>% group_by(Metric,Quintile) %>%
   summarise(max_y=quantile(.data[[yi]],.8,na.rm=TRUE),.groups='drop') %>%
   mutate(y_pos=ifelse(max_y>1,max_y*y_pos_scale,max_y*1.005))
 letters <- left_join(cld_data,y_positions,by=c('Metric','Quintile'))
 panel <- func_plot_cld(df_cat2,letters)+theme(strip.text=element_blank())+
   labs(x='SVI quintile',y=if(yi=='temp_baseline') 'July 2021 temperature (°C)' else 'Tree cover (%)')
 write.csv(letters,paste0('figures/figure2_',yi,'_letters.csv'),row.names=FALSE)
 panel
 })
}
# Preserve the original sequence: individual panels at 300 dpi, then assembly
# at 600 dpi. In the tested graphics stack, skipping the panel exports changes
# subsequent text/layout metrics. The runner isolates this script in a fresh R
# process so other figures cannot change that initialization sequence.
for(panel in panels) {
 preview <- tempfile(fileext='.png')
 ggsave(preview,panel,width=3.5,height=3,units='in',dpi=300,bg='white',device=ragg::agg_png)
 unlink(preview)
}
p <- wrap_plots(panels[[1]],panels[[2]],nrow=1,widths=c(1,1))+
 plot_annotation(tag_levels='a',theme=theme(plot.tag=element_text(face='bold',size=12)))
ggsave('figures/figure2.png',p,width=7.2,height=3.2,units='in',dpi=600,bg='white',device=ragg::agg_png)
