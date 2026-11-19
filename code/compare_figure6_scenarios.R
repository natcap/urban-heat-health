source("code/func_colors.R")
for(overlay_family in if(main_overlay_only) "Main" else if(target_overlay_only) "Target" else if(overlay_only) "Green" else c("Green","Target")) {
overlay_scenarios <- if(overlay_family=="Main") c("Green30","Target30") else paste0(overlay_family,c(10,20,30))
overlay <- filter(curves,scenario %in% overlay_scenarios)
main_labels <- c("Income deprivation","Age <5","Age ≥75",
                 "Ethnic-minority population share","Social Vulnerability Index")
overlay$indicator <- factor(main_labels[match(overlay$metric,metrics)],levels=main_labels[c(2,3,4,1,5)])
overlay$scenario <- factor(overlay$scenario,levels=overlay_scenarios)
ann <- overlay %>% group_by(indicator) %>% summarise(top=max(y+1.96*se)*1.04,.groups="drop")
# Target10 approaches zero: put labels below the arrows and move density down
# to keep all model curves unobscured. Main Figure 6 and Green remain unchanged.
ann$text_fraction <- if(overlay_family %in% c("Target","Main")) -.05 else .07
ann$floor_fraction <- if(overlay_family %in% c("Target","Main")) -.252 else -.132
# Use the observed 4,835-neighbourhood predictors, not the prediction grid.
# Verify the source still matches the fitted analysis before drawing densities.
vpath <- "data/derived/fig7_vulnerability_lsoa11_fig7_revised_equal_area.gpkg"
manifest <- read.csv("data/equity/overlay_input_checksums.csv")
stopifnot(unname(tools::md5sum(vpath))==manifest$md5[manifest$path==vpath])
vd <- st_drop_geometry(st_read(vpath,quiet=TRUE)) %>% mutate(SVI=overall_score)
stopifnot(nrow(vd)==4835,!anyDuplicated(vd$LSOA11CD))
dens <- bind_rows(lapply(seq_along(metrics),function(i) {
 xx <- as.numeric(scale(vd[[metrics[i]]]))
 stopifnot(all(is.finite(xx)))
 de <- density(xx,n=256)
 lim <- quantile(xx,c(.01,.99))
 data.frame(indicator=main_labels[i],x=de$x,height=de$y/max(de$y)) %>%
   filter(x>=lim[1],x<=lim[2])
})) %>% left_join(ann,by="indicator") %>%
 mutate(indicator=factor(indicator,levels=levels(overlay$indicator)),
        ymin=floor_fraction*top,ymax=ymin+.12*top*height)
g_overlay <- ggplot(overlay,aes(x,y,colour=scenario,fill=scenario,linetype=scenario))+
 geom_ribbon(data=dens,aes(x=x,ymin=ymin,ymax=ymax),inherit.aes=FALSE,
   fill="grey65",colour="grey45",linewidth=.15,alpha=.65)+
 geom_ribbon(aes(ymin=y-1.96*se,ymax=y+1.96*se),alpha=.14,colour=NA,linetype=0)+
 geom_line(linewidth=.8)+
 geom_vline(xintercept=0,linetype="dotted",colour="grey50",linewidth=.25)+
 geom_blank(data=ann,aes(x=0,y=top),inherit.aes=FALSE)+
 geom_blank(data=ann,aes(x=0,y=(floor_fraction-.038)*top),inherit.aes=FALSE)+
 annotate("segment",x=-.05,xend=-2,y=0,yend=0,
   colour="grey50",arrow=grid::arrow(length=grid::unit(.1,"cm")))+
 annotate("segment",x=.05,xend=2,y=0,yend=0,
   colour="grey50",arrow=grid::arrow(length=grid::unit(.1,"cm")))+
 geom_text(data=ann,aes(x=-1.5,y=text_fraction*top),label="Less Vulnerable",
   inherit.aes=FALSE,size=2.2,colour="grey40",fontface="italic")+
 geom_text(data=ann,aes(x=1.5,y=text_fraction*top),label="More Vulnerable",
   inherit.aes=FALSE,size=2.2,colour="grey40",fontface="italic")+
 facet_wrap(~indicator,ncol=3,scales="free")+
 scale_x_continuous(breaks=scales::breaks_width(1),expand=expansion(mult=c(.1,.05)))+
 scale_colour_manual(values=scenario_colors_new)+scale_fill_manual(values=scenario_colors_new)+
 scale_linetype_manual(values=setNames(if(overlay_family=="Main") c("solid","dashed") else c("dotted","dashed","solid"),overlay_scenarios))+
 scale_y_continuous(breaks=function(limits) {b <- pretty(c(0,limits[2]),n=4); b[b>=0]})+
 labs(x="Vulnerability metric (standardized z-score)",y="Predicted deaths averted per million residents",
   subtitle=paste0("Associations between neighborhood vulnerability and all-cause deaths averted (",
     if(overlay_family=="Main") "Green30 vs Target30" else paste0(overlay_family,"10/20/30"),")"),
   colour=NULL,fill=NULL,linetype=NULL)+
 theme_light(base_size=9)+theme(legend.position="bottom",legend.key.width=grid::unit(1.2,"cm"),
   strip.text=element_text(size=8,face="bold",colour="black"),
   strip.background=element_rect(fill="white",colour="grey65"),
   panel.grid.minor=element_blank(),panel.grid.major=element_line(colour="grey92",linewidth=.2),
   plot.subtitle=element_text(size=9),plot.margin=margin(8,12,8,12))
stopifnot(nrow(overlay)==1000*length(overlay_scenarios),length(unique(overlay$indicator))==5)
# Both scenarios inhabit each panel and therefore share its exact axis limits.
destination <- if(overlay_family=="Main") main_overlay_file else file.path(out,paste0("figure6_supplement_",tolower(overlay_family),"_overlay.png"))
ggsave(destination,g_overlay,
 width=7.5,height=5.5,dpi=600,device=ragg::agg_png)
}
stopifnot(identical(before,tools::md5sum(protected)))
print(stats[,c("metric","scenario","contrast")],row.names=FALSE)
message(if(redraw) "Only supplementary PNGs redrawn; saved numerical results unchanged." else
 "All existing figure files unchanged; Green30 input and contrast parity passed.")
