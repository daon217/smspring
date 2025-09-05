package edu.sm.app.dto;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Anything {
    int locId;
    String address;
    String AddrName;
    String img;
    double lat;
    double lng;
    int loc;
}